require "lua.client.core.network.LogicCode"
require "lua.client.core.network.playerData.BaseJsonInBound"
require "lua.client.core.network.playerData.PlayerDataRequest"
require "lua.client.core.network.playerData.unknown.UnknownOutBound"
require "lua.client.core.network.playerData.common.DynamicRewardInBound"
require "lua.client.core.network.playerData.common.CostInBound"
require "lua.client.core.network.playerData.common.MoneyInBound"
require "lua.client.core.network.playerData.common.MarketItemInBound"
require "lua.client.core.network.login.GuestAccountBindingInBound"
require "lua.client.core.network.login.LoginUtils"
require "lua.client.core.network.NetworkUtils"
require "lua.client.core.network.SilentRequest"
require "lua.client.core.network.remoteConfig.RemoteConfigSetOutbound"
require "lua.client.core.network.battleFormation.BattleFormationRequest"

--- @class NetworkMgr
NetworkMgr = Class(NetworkMgr)

--- @return void
function NetworkMgr:Ctor()
    --- @type CS_NetworkMgr
    self.networkMgr = zgUnity.networkMgr
    --- @type UnifiedNetwork_Connector
    self.connector = self.networkMgr.connector
    --- @type boolean
    self.isConnected = false
    --- @type boolean
    self.isLogin = false
    --- @type boolean
    self.isTryingConnect = false
    --- @type boolean
    self.isShowingDisconnect = false
    --- @type boolean
    self.isLocationAbuse = false
    --- @type HandShake
    self.handShake = nil
    --- @type LoadBalancer
    self.loadBalancer = nil
    --- @type Subject
    self.disconnect = nil

    self:PingServer()
    self:InitHandShake()
    self:InitConnectorStatus()
    self:InitReceivePackage()
    self:SubscribeDisconnect()
end

function NetworkMgr:InitHandShake()
    require "lua.client.core.network.handShake.HandShake"
    self.handShake = HandShake()
end

function NetworkMgr:InitReceivePackage()
    if self.networkMgr.ReceivePkgHandle == nil then
        --- @param message UnifiedNetwork_Message
        self.networkMgr.ReceivePkgHandle = function(message)
            RxMgr.receiveOpCode:Next(message.opCode)
            zg.netDispatcherMgr:TriggerEvent(message.opCode, message.buffer)
            if self.connector ~= nil then
                self.connector.messagePacker:ReleaseReceiveMessage(message)
            end
        end
    end
end

function NetworkMgr:InitConnectorStatus()
    self.connector.OnConnected = function()
        XDebug.Log("Connected")
        self.isConnected = true
        self.isTryingConnect = false
        RxMgr.connectComplete:Next()
    end

    self.connector.OnConnecting = function()
        XDebug.Log("Connecting")
    end

    self.connector.OnDisconnected = function()
        if self.isTryingConnect == true and self.loadBalancer ~= nil then
            self.loadBalancer:OnTryToConnectFailed()
        else
            self:OnDisconnected(DisconnectReason.NO_NETWORK_CONNECTION)
        end
    end

    self.connector.OnDisconnecting = function()
        XDebug.Log("Disconnecting")
    end
end

function NetworkMgr:PingServer()
    Coroutine.start(function()
        while true do
            coroutine.waitforseconds(40)
            if self.connector ~= nil and self.connector:IsConnected() then
                self.connector:Ping()
            end
        end
    end)
end

--- @return void
function NetworkMgr:InitListener()
    self.handShake:Ctor()
    self.handShake:InitListener()
    zg.netDispatcherMgr:AddListener(OpCode.DISCONNECT, EventDispatcherListener(nil, function(result)
        self:OnDisconnected(result:GetByte())
    end))
end

--- @return void
function NetworkMgr:Connect()
    if self.isLocationAbuse == true then
        self:TryToConnect()
    elseif NetConfig.isUseBalancingServer == true then
        if self.loadBalancer == nil then
            require "lua.client.core.network.loadBalancer.LoadBalancer"
            self.loadBalancer = LoadBalancer(self)
        end
        self.loadBalancer:GetListLogicServer(function()
            self:TryToConnect()
        end)
    else
        PlayerSettingData.logicAddress = string.format("%s:%d", NetConfig.logicServerIP, NetConfig.logicServerPort)
        self:TryToConnect()
    end
end

function NetworkMgr:TryToConnect()
    self.isTryingConnect = true
    self:InitListener()
    XDebug.Log(string.format("try to connect %s", PlayerSettingData.logicAddress))
    local address = PlayerSettingData.logicAddress:Split(':')
    if #address == 2 then
        self.networkMgr:Connect(address[1], address[2])
        --self.networkMgr:Connect("192.168.10.94", 8100)  --LinhNQ
        --self.networkMgr:Connect("192.168.2.93", 8100)  --DucPM
    else
        XDebug.Log(string.format("LogicAddress is invalid format: %s", PlayerSettingData.logicAddress))
    end
end

--- @return void
--- @param opCode number
--- @param outBound OutBound
function NetworkMgr:Send(opCode, outBound)
    self:CheckConnect(function()
        local result, content = pcall(function()
            local message = self.connector.messagePacker:BeginCreateMessageToSend(opCode)
            if message == nil then
                XDebug.Log("Can't create new message")
                return
            end
            if outBound ~= nil then
                outBound:Serialize(message.buffer)
            end
            self.connector:Send(message)

            self.connector.messagePacker:ReleaseSendMessage(message)
        end)
        if result == false then
            XDebug.Error(tostring(opCode) .. " =>" .. LogUtils.ToDetail(content))
        end
    end)
end

function NetworkMgr:SubscribeDisconnect()
    if self.disconnect == nil then
        self.disconnect = RxMgr.disconnect:Subscribe(function(reason)
            self:ShowNotificationDisconnect(reason)
        end)
    end
end

function NetworkMgr:UnsubscribeDisconnect()
    if self.disconnect then
        self.disconnect:Unsubscribe()
        self.disconnect = nil
    end
end

--- @return void
--- @param reason DisconnectReason
function NetworkMgr:OnDisconnected(reason)
    XDebug.Log("Disconnected")
    self.isConnected = false
    RxMgr.disconnect:Next(reason)
    if reason == nil then
        XDebug.Warning("don't know disconnect reason")
    end
end

function NetworkMgr:AutoDisconnect()
    self:UnsubscribeDisconnect()
    self.connector:Disconnect()
    TouchUtils.Reset()
end
--- @return void
--- @param reason DisconnectReason
function NetworkMgr:ShowNotificationDisconnect(reason)
    XDebug.Log(string.format("Disconnect: reason[%d] enable[%s] abuse[%s] popup_asset_bundle[%s]",
            reason, tostring(self.isShowingDisconnect), tostring(self.isLocationAbuse), tostring(PopupUtils.IsPopupShowing(UIPopupName.UIDownloadAssetBundle))))

    if self.isLocationAbuse or self.isShowingDisconnect or PopupUtils.IsPopupShowing(UIPopupName.UIDownloadAssetBundle) then
        return
    end

    local showDisconnect = function()
        XDebug.Log("Show disconnect...")
        self.isTryingConnect = false
        self.isLogin = false

        NetworkUtils.ResetAllSetUp()
	    --- remove maintain noti
        PopupUtils.ShowPopupDisconnect(reason, function()
            self.isShowingDisconnect = false
            SceneMgr.ResetToDownloadView()
        end)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end

    self.isShowingDisconnect = true
    if SceneMgr.IsHomeScene() then
        showDisconnect()
    else
        local switchScene
        switchScene = RxMgr.switchScene:Subscribe(function(sceneName)
            switchScene:Unsubscribe()
            showDisconnect()
        end)
    end
end

--- @return void
function NetworkMgr:CheckConnect(callbackConnected)
    if zg.networkMgr.isShowingDisconnect then
        XDebug.Log("Showing disconnect")
    else
        if callbackConnected == nil then
            XDebug.Error("callbackConnected is nil")
            return
        end

        if self.connector == nil then
            XDebug.Log("connect can't be nil")
            return
        end

        if self.isConnected then
            callbackConnected()
        elseif self.isTryingConnect then
            XDebug.Log("Is trying connect")
        else
            local listener
            listener = RxMgr.connectComplete:Subscribe(function()
                listener:Unsubscribe()
                callbackConnected()
            end)
            self:Connect()
        end
    end
end