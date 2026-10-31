local base64 = require("lua.client.utils.base64.Base64Helper")

--- @class PlayerSettingData
PlayerSettingData = {
    --- @type number
    guestToken = nil,
    --- @type number
    loginId = nil,
    --- @type EmailState
    emailState = nil,
    --- @type AuthMethod
    authMethod = nil,
    --- @type string
    userName = nil,
    --- @type string
    passwordHash = nil,
    --- @type number
    serverId = nil,
    --- @type number id from server
    playerId = nil,
    --- @type string id from social network
    userId = nil,
    --- @type number
    soundValue = 1,
    --- @type number
    musicValue = 1,
    --- @type boolean
    isMuteSound = false,
    --- @type boolean
    isMuteMusic = false,
    --- @type GraphicQualityType
    graphicQuality = GraphicQualityType.HIGH,
    --- @type string
    language = nil,
    --- @type boolean
    isDungeonQuick = false,
    --- @type boolean
    isHideVipChat = false,
    --- @type boolean
    isBlockWorldChat = false,
    --- @type boolean
    isBlockGuildChat = false,
    --- @type boolean
    isBlockRecruitChat = false,
    --- @type boolean
    isBlockDomainsTeamChat = false,
    --- @type boolean
    isBlockDomainsRecruitChat = false,

    --- @type boolean
    isDebugging = true,
    --- @type number
    battleSpeed = 1,
    --- @type number
    balancingTime = os.time(),
    --- @type string
    logicAddress = nil,
    --- @type string
    sortHeroCollection = nil,
    --- @type string
    unlockServer = nil,
    --- @type boolean
    isSkipArena = false,
    --- @type boolean
    isSkipVideoBattle = false,
    --- @type boolean
    isAutoNextBattle = false,
    --- @type boolean
    isSkipDiceAnim = false
}





---@type Dictionary
TargetFrameRate = Dictionary()
TargetFrameRate:Add(GraphicQualityType.LOW, 30)
TargetFrameRate:Add(GraphicQualityType.MEDIUM, 40)
TargetFrameRate:Add(GraphicQualityType.HIGH, 50)

--- @class PlayerSetting
PlayerSetting = {}

PlayerSetting.serverLock = ""
PlayerSetting.remoteUnlockSpeedBattle = nil



function PlayerSetting.ClearPlayerData()
    PlayerSettingData.authMethod = nil
    PlayerSettingData.userName = nil
    PlayerSettingData.passwordHash = nil
    PlayerSettingData.serverId = nil
    PlayerSettingData.playerId = nil
    PlayerSettingData.userId = nil
    PlayerSettingData.battleSpeed = 1
    PlayerSettingData.isSkipVideoBattle = LOWER_DEVICE
    PlayerSettingData.isSkipDiceAnim = false
    PlayerSetting.remoteUnlockSpeedBattle = nil
end

function PlayerSetting.SwitchSpeed()
    if PlayerSettingData.battleSpeed == 2 then
        PlayerSettingData.battleSpeed = 1
    else
        PlayerSettingData.battleSpeed = 2
    end
    PlayerSetting.SaveData()
end

function PlayerSetting.SetAutoNextBattle(val)
    PlayerSettingData.isAutoNextBattle = val
    PlayerSetting.SaveData()
end

function PlayerSetting.SetToggleAutoNextBattle()
    PlayerSettingData.isAutoNextBattle = not PlayerSettingData.isAutoNextBattle
    PlayerSetting.SaveData()
end

function PlayerSetting.ToggleSkipVideoBattle()
    if LOWER_DEVICE then
        PlayerSettingData.isSkipVideoBattle = true
    else
        PlayerSettingData.isSkipVideoBattle = not PlayerSettingData.isSkipVideoBattle
    end
    PlayerSetting.SaveData()
end

function PlayerSetting.ToggleDiceAnim()
    PlayerSettingData.isSkipDiceAnim = not PlayerSettingData.isSkipDiceAnim
    PlayerSetting.SaveData()
end

---@return boolean
function PlayerSetting.GetKeyServer(serverId)
    return string.format("S%s,", serverId)
end

function PlayerSetting.SetUnlockServer(serverId)
    local key = PlayerSetting.GetKeyServer(serverId)
    if PlayerSettingData.unlockServer == nil then
        PlayerSettingData.unlockServer = key
        PlayerSetting.SaveData()
    elseif not string.find(PlayerSettingData.unlockServer, key) then
        PlayerSettingData.unlockServer = string.format("%s%s", PlayerSettingData.unlockServer, key)
        PlayerSetting.SaveData()
    end
end

---@return boolean
function PlayerSetting.IsUnlockServer(serverId)
    local unlock = false
    if PlayerSettingData.unlockServer ~= nil then
        unlock = string.find(PlayerSettingData.unlockServer, PlayerSetting.GetKeyServer(serverId))
    end
    return unlock
end

--- @return void
function PlayerSetting.IsCanShowServer(serverId)
    local keyServer = PlayerSetting.GetKeyServer(serverId)
    return (not string.find(PlayerSetting.serverLock, keyServer)) or PlayerSetting.IsUnlockServer(serverId)
end

function PlayerSetting.SaveData()
    local playerJson = json.encode(PlayerSettingData)
    local playerBase64 = base64:encode64(playerJson)
    U_PlayerPrefs.SetString(PlayerPrefsKey.PLAYER_SETTING, playerBase64)
end

function PlayerSetting.LoadData()
    local playerBase64 = U_PlayerPrefs.GetString(PlayerPrefsKey.PLAYER_SETTING, "")
    local playerJson = base64:decode64(playerBase64)
    local rawData = json.decode(playerJson)

    for key, value in pairs(rawData) do
        PlayerSettingData[key] = value
    end
    if LOWER_DEVICE then
        PlayerSettingData.isSkipVideoBattle = true
    end
    --print("DONE LOAD DATA ", LogUtils.ToDetail(PlayerSettingData))
end

function PlayerSetting.SetLoginByToken()
    PlayerSettingData.authMethod = AuthMethod.LOGIN_BY_TOKEN
    PlayerSetting.SaveData()
end

--- @return void
--- @param userName string
--- @param passwordHash string
function PlayerSetting.SetLoginByUserName(userName, passwordHash)
    PlayerSettingData.authMethod = AuthMethod.LOGIN_BY_USER_NAME
    PlayerSettingData.userName = userName
    PlayerSettingData.passwordHash = passwordHash
    PlayerSetting.SaveData()
end

--- @return void
--- @param authMethod AuthMethod
--- @param loginId string
function PlayerSetting.SetLoginByMethod(authMethod, loginId)
    if authMethod == AuthMethod.REGISTER_BY_APPLE then
        PlayerSettingData.authMethod = AuthMethod.LOGIN_BY_APPLE
    elseif authMethod == AuthMethod.REGISTER_BY_GOOGLE then
        PlayerSettingData.authMethod = AuthMethod.LOGIN_BY_GOOGLE
    elseif authMethod == AuthMethod.REGISTER_BY_FACEBOOK then
        PlayerSettingData.authMethod = AuthMethod.LOGIN_BY_FACEBOOK
    else
        PlayerSettingData.authMethod = authMethod
    end
    PlayerSettingData.loginId = loginId
    PlayerSetting.SaveData()
end

--- @return boolean
function PlayerSetting.IsSavedData()
    return U_PlayerPrefs.HasKey(PlayerPrefsKey.PLAYER_SETTING)
end

--- @return boolean
function PlayerSetting.IsLogin()
    return PlayerSettingData.authMethod ~= nil
end

function PlayerSetting.SaveBestAddress(bestAddress)
    XDebug.Log(string.format("best_address: %s", tostring(bestAddress)))
    PlayerSettingData.logicAddress = bestAddress
    PlayerSettingData.balancingTime = os.time()
    PlayerSetting.SaveData()
end
