--- @class LoginByUPOutBound : OutBound
LoginByUPOutBound = Class(LoginByUPOutBound, OutBound)

--- @return void
function LoginByUPOutBound:Ctor(userName, passwordHash)
    --- @type string
    self.authMethod = AuthMethod.LOGIN_BY_USER_NAME
    --- @type string
    self.userName = userName
    --- @type string
    self.passwordHash = passwordHash
    --- @type string
    self.advertisingId = nil
end

--- @return void
function LoginByUPOutBound:SaveData()
    PlayerSettingData.authMethod = self.authMethod
    PlayerSettingData.userName = self.userName
    PlayerSettingData.passwordHash = self.passwordHash
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function LoginByUPOutBound:Serialize(buffer)
    --- @type string
    self.clientHandShake = SHA2.shaHex256(string.format("%s%s%s%s",
            zg.networkMgr.handShake.sharedSecret, zg.networkMgr.handShake.sessionSecret, string.lower(self.userName), self.passwordHash))
    buffer:PutByte(self.authMethod)
    buffer:PutString(self.userName)
    buffer:PutString(self.passwordHash, false)
    buffer:PutString(self.clientHandShake, false)
    if self.advertisingId ~= nil then
        buffer:PutString(self.advertisingId, false)
    end
end

--- @return void
function LoginByUPOutBound:ToString()
    return LogUtils.ToDetail(self)
end