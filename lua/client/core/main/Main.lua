require "lua.client.core.UnityLib"

--- @type CS_ZgMgr
zgUnity = zgUnity

local function InitGlobal()
    require "lua.client.core.GlobalVariables"
end

local function RequireBaseFiles()
    print("require base files")
    require "lua.libs.Class"
    require "lua.client.utils.json"
    require "lua.client.utils.Coroutine"
    require "lua.client.core.main.NetConfig"
    require "lua.libs.collection.List"
    require "lua.libs.collection.Dictionary"
    require "lua.client.config.const.ResourceType"
    require "lua.client.config.const.ClientItemConstants"
    require "lua.client.utils.ResourceLoadUtils"
    require "lua.client.utils.PrefabLoadUtils"
    require "lua.client.core.main.LRUCache"
    require "lua.client.core.RxMgr"
    require "lua.logicBattle.enum.battle.GameMode"
    require "lua.client.utils.CsvReaderUtils"
    require "lua.libs.StringUtils"
    require "lua.libs.LogUtils"
    require "lua.client.utils.XDebug"
    require "lua.client.config.PlayerPrefsKey"
    require "lua.client.core.network.LogicCode"
    require "lua.client.core.network.NetworkUtils"
end

--- @class Main
Main = {}

--- @return string
function Main.GetVersionInfo()
    --print("Main.GetVersionInfo")
    return string.format(" %s %s-%d %s %s", LanguageUtils.LocalizeCommon("game_version"),
            VERSION_CLIENT_BUILD, GOOGLE_SCRIPT.patch, DEVICE_MODEL, U_SystemInfo.operatingSystem)
end

local function RemoveLua()
    local cacheFile = {}
    local count = 1
    -- JUST REMOVE CREATE BY TEAM, NOT LIB OF LUA
    --- @param file string
    for file, _ in pairs(package.loaded) do
        local index = string.find(file, "lua.")
        if index ~= nil then
            cacheFile[count] = file
            count = count + 1
        end
    end
    for i, v in ipairs(cacheFile) do
        package.loaded[v] = nil
    end
end

local function DestroyObject()
    zg:OnDestroy()

    local childCount = zgUnity.transform.childCount
    if childCount > 0 then
        for i = 1, childCount do
            CS.UnityEngine.Object.Destroy(zgUnity.transform:GetChild(childCount - i).gameObject)
        end
    end
end

function Main.ResetGame()
    print("Reset Game")

    RemoveLua()
    DestroyObject()
    zgUnity:RunGame()
end

-- https://github.com/Tencent/xLua/blob/master/Assets/XLua/Doc/faq.md
--- @return boolean
--- @param unity_object System_Object
function Main.IsNull(unity_object)
    if unity_object == nil then
        return true
    end

    if type(unity_object) == "userdata" and unity_object.IsNull ~= nil then
        return unity_object:IsNull()
    end

    return false
end

function Main.CreateZg()
    print("Create ZG")
    require("lua.client.core.ZgMgr")
    zg = ZgMgr()
    zg:Run()
end

local function SetTestState()
    print("Set Test State")
    if IS_EDITOR_PLATFORM then
        zgUnity.IsTest = true
    else
        zgUnity.IsTest = false
        local deviceIds = {
            -- android
            "8ad4247105b77d5130b048a30f1470fd", -- phuong 1
            "6d3ed140c95149cde72df909e8d45985", -- phuong 2
            "86dc24900a2813a836eb70726db55b6a", -- haivd cty pc
            "f9d7dec413aff7c7b96c79f49e0efbcc", -- haivd home pc
            "f7bf2f24120b0b9e94523d96c5379c0c",
            "68122358f93ae8f1d00209e5a8a08be0", -- mayreview
            "f6a64def3fae2592bea059fdfc55de03", -- phuong 3
            "52719ad7423556efb733246deede06b5", -- phuong 4
            "18e38fd3c9a38d8b1906791c07cd227a", -- hanhnbUA
            "dca2e95820d139672d6a8dd18fed0874", -- creatives
            "01790cf09b86d45533ee0290ec517ad1", -- UA
            "7b376c6efede47856177b0f29fb62eb9", -- UA
            "caf31be70ac25bf2aa5ce64c69f86b76", -- haivd
            "5891918b186c46baf39cc31c9309bfaf", -- haivd
            "5a15b6fc6c94276fa48d49ae310f746e", -- linh
            "50dbfceeebab7c35fef8a3ebb3f7cc40", -- cuongnt
            -- iOS
            "FFDA9A5B-8A27-45C1-8D0C-551D20AD4CDB", -- phuong
            "DF7C0FB2-80DD-4F5B-BB92-6A3E86ABDB7C", -- haivd
            "0C86D1DE-51FE-4815-B8FE-F2D8A475264E", --
        }
        for _, deviceId in ipairs(deviceIds) do
            if DEVICE_INFO == deviceId then
                zgUnity.IsTest = true
                return
            end
        end
    end
end

local function SetSupportTool()
    SetTestState()

    --- @type SupportTool
    local supportTool = require("lua.client.utils.SupportTool")
    if zgUnity.IsTest and zgUnity.IsPVE == false and zgUnity.IsBossFight == false then
        local reporter = CS.UnityEngine.Object.FindObjectOfType(typeof(CS.Reporter))

        if reporter == nil then
            print("Create Reporter")
            U_GameUtils.Instantiate("Reporter")
        end

        supportTool.InitTool()
    else
        local result, message = pcall(function()
            local currentValue = U_PlayerPrefs.GetInt(PlayerPrefsKey.SERVER_KEY, supportTool.ServerIndex.Production)
            supportTool.SetNetConfig(currentValue)
            print("SetNetConfig: " .. currentValue)
            Main.CreateZg()
        end)
        if result == false then
            print(message)
        end
    end
end

function Main.Start()
    print("start game")

    InitGlobal()

    RequireBaseFiles()

    SetSupportTool()

    U_Resources.UnloadUnusedAssets()
end




