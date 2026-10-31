--- @class LoadBalancer
LoadBalancer = Class(LoadBalancer)

local BALANCER_URL = "http://%s:%d/balancer/health?version=%d"
local NUMBER_BIT_VERSION = 8

--- @param networkMgr NetworkMgr
function LoadBalancer:Ctor(networkMgr)
    self.networkMgr = networkMgr
    --- @type number
    self.timeReset = nil
    --- @type string
    self.location = nil
    --- @type number
    self.finishMaintainTime = nil
    --- @type Dictionary
    self.locationServerDict = nil
end

function LoadBalancer:NeedFindNewAddress()
    if PlayerSettingData.logicAddress == nil or PlayerSettingData.balancingTime == nil then
        return true
    end

    for _, address in pairs(self.locationServerDict:GetItems()) do
        if address == PlayerSettingData.logicAddress and os.time() - PlayerSettingData.balancingTime < self.timeReset then
            return false
        end
    end
    return true
end

function LoadBalancer:ParseData(content)
    local parseData = json.decode(content)
    local serverList = parseData['0']
    self.timeReset = parseData['1']
    self.location = parseData['2']
    self.finishMaintainTime = parseData['3']

    self.locationServerDict = Dictionary()
    for k, v in pairs(serverList) do
        self.locationServerDict:Add(k, v)
    end
end

function LoadBalancer:GetBalancerUrl()
    local bitTable = {}
    local patch = BitUtils.GetBitTableByNumber(GOOGLE_SCRIPT.patch, NUMBER_BIT_VERSION)
    local build = VERSION:Split('.')
    for _, number in ipairs(build) do
        bitTable = BitUtils.MergerBit(bitTable, BitUtils.GetBitTableByNumber(tonumber(number), NUMBER_BIT_VERSION))
    end
    bitTable = BitUtils.MergerBit(bitTable, patch)
    local numberVersion = BitUtils.GetNumberByBitTable(bitTable)
    return string.format(BALANCER_URL, NetConfig.loadBalancerIP, NetConfig.loadBalancerPort, numberVersion)
end

--- @param onSuccess function
function LoadBalancer:GetBalancerHealth(onSuccess)
    local onSuccess = function(content)
        UIPopupWaitingUtils.StopWaitingCoroutine()
        onSuccess(content)
    end
    local onFailed = function()
        UIPopupWaitingUtils.Disconnect(DisconnectReason.CANT_DOWNLOAD_BALANCER)
    end
    UIPopupWaitingUtils.ShowWaiting()
    NetworkUtils.TryRequestData(3, self:GetBalancerUrl(), onSuccess, onFailed)
end

function LoadBalancer:CheckServerHealth(onFinish)
    local priority = 0.1
    local ipDict = Dictionary()
    local canAddToDict = true
    local startTime = os.clock()
    local totalServer = self.locationServerDict:Count()
    local numberServerPingError = 0
    UIPopupWaitingUtils.ShowWaiting()
    for location, address in pairs(self.locationServerDict:GetItems()) do
        local onSuccess = function(lcContent)
            local deltaTime = os.clock() - startTime
            XDebug.Log(string.format('address: %s, deltaTime: %s, lc: %s', address, deltaTime, lcContent))
            --- @type {ip, result, location, priority}
            local lcParseData = json.decode(lcContent)
            local logicAddress = lcParseData['0']
            self.locationServerDict:Add(location, logicAddress)
            lcParseData['3'] = location
            lcParseData['4'] = (location == self.location and deltaTime - priority or deltaTime)
            local isSuccess = lcParseData['1'] == LogicCode.SUCCESS
            if ipDict:Count() == 0 then
                if isSuccess then
                    ipDict:Add(logicAddress, lcParseData)
                    Coroutine.start(function()
                        coroutine.waitforseconds(0.1)
                        canAddToDict = false
                        local bestAddress = self:SelectBestIp(ipDict)
                        PlayerSetting.SaveBestAddress(bestAddress)
                        UIPopupWaitingUtils.StopWaitingCoroutine()
                        onFinish()
                    end)
                else
                    onFailed(string.format(lcContent))
                end
            elseif canAddToDict then
                if isSuccess then
                    ipDict:Add(logicAddress, lcParseData)
                end
            end
        end
        local onFailed = function(error)
            numberServerPingError = numberServerPingError + 1
            if numberServerPingError == totalServer then
                UIPopupWaitingUtils.Disconnect(DisconnectReason.CANT_PING_ANY_SERVER)
            end
            XDebug.Log("Cant ping to server: " .. error)
        end
        U_GameUtils.DownloadScript(string.format("http://%s/server/health", address), onSuccess, onFailed)
    end
end

--- @param ipDict Dictionary
function LoadBalancer:SelectBestIp(ipDict)
    local bestIP
    local bestTime
    for tempIp, data in pairs(ipDict:GetItems()) do
        if bestTime == nil or bestTime > data['4'] then
            bestIP = tempIp
            bestTime = data['4']
        end
    end
    return bestIP
end

--- @return void
function LoadBalancer:GetListLogicServer(onFinish)
    self:GetBalancerHealth(function(content)
        self:ParseData(content)
        if self:IsServerMaintain() then
            NetworkUtils.ResetAllSetUp()
            PopupUtils.ShowPopupMaintenance(self.finishMaintainTime)
        else
            if self:NeedFindNewAddress() == false then
                onFinish()
            else
                self:CheckServerHealth(onFinish)
            end
        end
    end)
end

function LoadBalancer:IsServerMaintain()
    return self.locationServerDict:Count() == 0
end

function LoadBalancer:OnTryToConnectFailed()
    for k, v in pairs(self.locationServerDict:GetItems()) do
        if v == PlayerSettingData.logicAddress then
            self.locationServerDict:RemoveByKey(k)
            break
        end
    end
    if self.locationServerDict:Count() == 0 then
        self:OnDisconnected(DisconnectReason.NO_NETWORK_CONNECTION)
        return
    end
    self:CheckServerHealth(function()
        zg.networkMgr:TryToConnect()
    end)
end