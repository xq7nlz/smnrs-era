--- @class AuthenticationInBound
AuthenticationInBound = Class(AuthenticationInBound)

local SUNGAME_API_TOKEN_KEY = "Hash"

--- @return void
function AuthenticationInBound:Ctor()

end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function AuthenticationInBound:ReadBuffer(buffer)
    ---@type AuthProvider
    self.guestProvider = buffer:GetByte()
    ---@type string
    self.guestToken = buffer:GetString(false)
    ---@type string
    self.userName = buffer:GetString(false)
    ---@type string
    self.facebookId = buffer:GetString(false)
    ---@type string
    self.appleId = buffer:GetString(false)
    ---@type string
    self.googleId = buffer:GetString(false)
    ---@type string
    self.sunGameId = buffer:GetLong()
    ---@type string
    self.sungameApiToken = buffer:GetString(false)
    ---@type string
    self.email = buffer:GetString(false)
    ---@type EmailState
    self.emailState = buffer:GetByte()
    ---@type Dictionary
    self.remoteConfigMap = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        self.remoteConfigMap:Add(buffer:GetString(false), buffer:GetString(false))
    end
    zg.playerData.remoteConfigAccount = self.remoteConfigMap:Get(REMOTE_CONFIG_ACCOUNT_KEY)
    if zg.playerData.remoteConfigAccount == nil then
        zg.playerData.remoteConfigAccount = {}
    else
        zg.playerData.remoteConfigAccount = json.decode(zg.playerData.remoteConfigAccount)
    end

    PlayerSettingData.guestToken = self.guestToken
    PlayerSettingData.emailState = self.emailState

    if PlayerSettingData.authMethod == AuthMethod.LOGIN_BY_SUN_GAME_USER_ID or PlayerSettingData.authMethod == AuthMethod.LOGIN_BY_SUN_GAME then
        PlayerSettingData.loginId = self.sunGameId
    end
    self:SaveLocalApiToken()
end

function AuthenticationInBound:SaveLocalApiToken()
    U_PlayerPrefs.SetString(SUNGAME_API_TOKEN_KEY, self.sungameApiToken)
end

function AuthenticationInBound:IsAccountBinding()
    return self.userName ~= ""
            or self.googleId ~= ""
            or self.appleId ~= ""
            or self.facebookId ~= ""
            or (self.sunGameId > 0 and self.sungameApiToken ~= "")
end

function AuthenticationInBound:IsAccountBindingNotFansipan()
    return self.userName ~= ""
end

--- @param callbackSuccess function
--- @param callbackFailed function
function AuthenticationInBound.Request(callbackSuccess, callbackFailed)
    PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.AUTHENTICATION }, callbackSuccess, callbackFailed, true, true)
end

--- @return boolean
function AuthenticationInBound:IsAlreadySignInSungame()
    return self.sunGameId > 0 and self.sungameApiToken ~= ""
end

return AuthenticationInBound