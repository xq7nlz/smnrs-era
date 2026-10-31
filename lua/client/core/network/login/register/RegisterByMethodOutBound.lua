--- @class RegisterByMethodOutBound : OutBound
RegisterByMethodOutBound = Class(RegisterByMethodOutBound, OutBound)
--- @return void
function RegisterByMethodOutBound:Ctor(authMethod, userId)
    --- @type number
    self.authMethod = authMethod
    --- @type string
    self.userId = userId
    --- @type number
    self.serverId = -1
    --- @type string
    self.advertisingId = nil
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function RegisterByMethodOutBound:Serialize(buffer)
    ---@type string
    self.clientHandShake = SHA2.shaHex256(string.format("%s%s%s", zg.networkMgr.handShake.sharedSecret,
            zg.networkMgr.handShake.sessionSecret, self.userId))
    buffer:PutByte(self.authMethod)
    --buffer:PutByte(AuthProvider.GetCurrentAuthProvider())
    --buffer:PutString(DEVICE_INFO, false)
    buffer:PutString(self.userId)
    buffer:PutString(self.clientHandShake, false)
    buffer:PutShort(self.serverId)
    if self.advertisingId ~= nil then
        buffer:PutString(self.advertisingId, false)
    end
end

--- @return void
function RegisterByMethodOutBound:ToString()
    return LogUtils.ToDetail(self)
end