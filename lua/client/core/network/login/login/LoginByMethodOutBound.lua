--- @class LoginByMethodOutBound : OutBound
LoginByMethodOutBound = Class(LoginByMethodOutBound, OutBound)
--- @return void
function LoginByMethodOutBound:Ctor(authMethod, userId)
    --- @type number
    self.authMethod = authMethod
    --- @type string
    self.userId = userId
    --- @type string
    self.advertisingId = nil
end

--- @return void
function LoginByMethodOutBound:SaveData()
    PlayerSettingData.authMethod = self.authMethod
    PlayerSettingData.loginId = self.userId
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function LoginByMethodOutBound:Serialize(buffer)
    --- @type string
    self.clientHandShake = SHA2.shaHex256(string.format("%s%s%s",
            zg.networkMgr.handShake.sharedSecret, zg.networkMgr.handShake.sessionSecret, self.userId))
    buffer:PutByte(self.authMethod)
    buffer:PutString(self.userId)
    buffer:PutString(self.clientHandShake, false)
    if self.advertisingId ~= nil then
        buffer:PutString(self.advertisingId, false)
    end
end

--- @return void
function LoginByMethodOutBound:ToString()
    return LogUtils.ToDetail(self)
end