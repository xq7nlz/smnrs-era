--- @class RegisterByTokenOutBound : OutBound
RegisterByTokenOutBound = Class(RegisterByTokenOutBound, LoginByTokenOutBound)


--- @return void
function RegisterByTokenOutBound:Ctor(serverId)
    LoginByTokenOutBound.Ctor(self)
    --- @type number
    self.authMethod = AuthMethod.REGISTER_BY_TOKEN
    --- @type number
    self.serverId = -1
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function RegisterByTokenOutBound:Serialize(buffer)
    LoginByTokenOutBound.SetBaseData(self, buffer)
    self:SetServerId(buffer)
    LoginByTokenOutBound.SetAdvertisingId(self, buffer)
end

--- @param buffer UnifiedNetwork_ByteBuf
function RegisterByTokenOutBound:SetServerId(buffer)
    buffer:PutShort(self.serverId)
end