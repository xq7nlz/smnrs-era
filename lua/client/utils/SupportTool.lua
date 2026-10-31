local Reporter = CS.Reporter
local MAX_SERVER = 4

local function ButtonEndTutorial()
    local tutorialButton = CS.ButtonDataTool()
    tutorialButton.text = "end_tut"
    tutorialButton.onClick = function()
        require "lua.client.core.network.fake.FakeDataRequest"
        if zg.networkMgr.isLogin == true then
            FakeDataRequest.FakeTutorial(0, true, 0)
        else
            print("Need login to fake end tutorial")
        end
    end
    Reporter.buttons:Add(tutorialButton)
end

---@class ServerIndex
local ServerIndex = {
    Sandbox = 1,
    Production = 2,
    Staging = 3,
    Dev = 4,
}

local function ServerByIndex(index)
    if index == ServerIndex.Sandbox then
        return "sand_box"
    elseif index == ServerIndex.Production then
        return "production"
    elseif index == ServerIndex.Staging then
        return "staging"
    elseif index == ServerIndex.Dev then
        return "dev"
    end
end

--- @return void
---@param index ServerIndex
local function SetNetConfig(index)
    if index == ServerIndex.Sandbox then
        NetConfig.isProduction = false
        NetConfig.isUseBalancingServer = false
        NetConfig.loadBalancerIP = "34.126.86.246"
        NetConfig.loadBalancerPort = 8150
        NetConfig.logicServerIP = "34.126.169.107"
        NetConfig.logicServerPort = 8100
    elseif index == ServerIndex.Production then
        NetConfig.isProduction = true
        NetConfig.isUseBalancingServer = true
        NetConfig.loadBalancerIP = "35.240.141.95"
        NetConfig.loadBalancerPort = 8150
        NetConfig.logServerIP = "35.240.141.95"
    elseif index == ServerIndex.Staging then
        NetConfig.isProduction = false
        NetConfig.isUseBalancingServer = false
        NetConfig.loadBalancerIP = "35.240.141.95"
        NetConfig.loadBalancerPort = 8150
        NetConfig.logicServerIP = "35.213.172.58"
        NetConfig.logicServerPort = 8104
    elseif index == ServerIndex.Dev then
        NetConfig.isProduction = false
        NetConfig.isUseBalancingServer = false
        NetConfig.loadBalancerIP = "34.87.189.128"
        NetConfig.loadBalancerPort = 8150
        NetConfig.logicServerIP = "34.87.189.128"
        NetConfig.logicServerPort = 8100
    end
    if SungameDefine ~= nil then
        SungameDefine.IS_PROD = NetConfig.isProduction
    end
end

--- @return void
local function NetworkConfig()
    local index = U_PlayerPrefs.GetInt(PlayerPrefsKey.SERVER_KEY, ServerIndex.Production)
    if index > MAX_SERVER or index < 1 then
        index = 1
    end
    
    print(string.format("Current Server: %s", ServerByIndex(index)))
    SetNetConfig(index)
end

local function ButtonServerSelection()
    local currentValue = U_PlayerPrefs.GetInt(PlayerPrefsKey.SERVER_KEY, ServerIndex.Production)
    local btnSelectServer = CS.ButtonDataTool()
    local setServerConfig = function()
        btnSelectServer.text = ServerByIndex(currentValue)
        NetworkConfig()
    end
    setServerConfig()
    btnSelectServer.onClick = function()
        currentValue = (currentValue % MAX_SERVER) + 1
        U_PlayerPrefs.SetInt(PlayerPrefsKey.SERVER_KEY, currentValue)
        setServerConfig()
    end
    Reporter.buttons:Add(btnSelectServer)
end

local function ButtonStartGame()
    local button = CS.ButtonDataTool()
    button.text = "START GAME"
    button.onClick = function()
        Main.CreateZg()
    end
    Reporter.buttons:Add(button)
end

local function FixClick()
    if uiCanvas ~= nil then
        if uiCanvas.config.eventSystem.enabled == true then
            Coroutine.start(function()
                uiCanvas.config.eventSystem.enabled = false
                coroutine.waitforendofframe()
                uiCanvas.config.eventSystem.enabled = true
            end)
        end
    end
end

local function ButtonTutSummoner()
    local button = CS.ButtonDataTool()
    button.text = "TUT SUMMONER"
    button.onClick = function()
        require("lua.client.core.network.fake.FakeDataRequest")
        FakeDataRequest.FakeMoney(110, 1000)
        FakeDataRequest.FakeMoney(0, 10000000)
        FixClick()
    end
    Reporter.buttons:Add(button)
end

--- @return void
local function InitTool()
    if Reporter ~= nil then
        if Reporter.buttons.Count == 0 then
            ButtonStartGame()
            ButtonServerSelection()
            ButtonEndTutorial()
            ButtonTutSummoner()
        else
            NetworkConfig()
            Main.CreateZg()
        end
    end
end

--- @class SupportTool
local SupportTool = {}
SupportTool.InitTool = InitTool
SupportTool.SetNetConfig = SetNetConfig
SupportTool.ServerIndex = ServerIndex

return SupportTool