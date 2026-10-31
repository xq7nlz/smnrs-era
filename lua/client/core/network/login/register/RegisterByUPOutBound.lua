--- @class RegisterByUPOutBound : OutBound
RegisterByUPOutBound = Class(RegisterByUPOutBound, OutBound)


--- @return void
function RegisterByUPOutBound:Ctor(userName, passwordHash, serverId)
    --- @type number
    self.authMethod = AuthMethod.REGISTER_BY_USER_NAME
    --- @type number
    self.userName = userName
    --- @type string
    self.hashedPassword = passwordHash
    --- @type number
    self.serverId = serverId or -1
    --- @type string
    self.advertisingId = nil
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function RegisterByUPOutBound:Serialize(buffer)
    --- @type string
    self.clientHandShake = SHA2.shaHex256(string.format("%s%s%s%s",
            zg.networkMgr.handShake.sharedSecret, zg.networkMgr.handShake.sessionSecret, string.lower(self.userName), self.hashedPassword))
    buffer:PutByte(self.authMethod)
    --buffer:PutByte(AuthProvider.GetCurrentAuthProvider())
    --buffer:PutString(DEVICE_INFO, false)
    buffer:PutString(self.userName)
    buffer:PutString(self.hashedPassword, false)
    buffer:PutString(self.clientHandShake, false)
    buffer:PutShort(self.serverId)
    if self.advertisingId ~= nil then
        buffer:PutString(self.advertisingId, false)
    end
end

--- @return void
function RegisterByUPOutBound:ToString()
    return LogUtils.ToDetail(self)
end