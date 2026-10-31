--- login by device info, that 's it
--- @class LoginByTokenOutBound : OutBound
LoginByTokenOutBound = Class(LoginByTokenOutBound, OutBound)

--- @return void
function LoginByTokenOutBound:Ctor(token)
    --- @type string
    self.authMethod = AuthMethod.LOGIN_BY_TOKEN
    --- @type string
    self.advertisingId = nil
    if token == nil then
        self.token = DEVICE_INFO
    else
        self.token = token
    end
end

--- @return void
function LoginByTokenOutBound:SaveData()
    PlayerSettingData.authMethod = self.authMethod
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function LoginByTokenOutBound:Serialize(buffer)
    self:SetBaseData(buffer)
    self:SetAdvertisingId(buffer)
end

--- @param buffer UnifiedNetwork_ByteBuf
function LoginByTokenOutBound:SetBaseData(buffer)
    local provider = AuthProvider.GetCurrentAuthProvider()
    --XDebug.Log(string.format("share = %s session = %s  author = %s  token = %s", zg.networkMgr.handShake.sharedSecret, zg.networkMgr.handShake.sessionSecret, self.authProvider, self.authToken))
    --- @type string
    local clientHandShake = SHA2.shaHex256(string.format("%s%s%d%s",
            zg.networkMgr.handShake.sharedSecret, zg.networkMgr.handShake.sessionSecret, provider, self.token))
    buffer:PutByte(self.authMethod)
    buffer:PutByte(provider)
    buffer:PutString(self.token, false)
    buffer:PutString(clientHandShake, false)
end

--- @param buffer UnifiedNetwork_ByteBuf
function LoginByTokenOutBound:SetAdvertisingId(buffer)
    if self.advertisingId ~= nil then
        buffer:PutString(self.advertisingId, false)
    end
end

--- @return void
function LoginByTokenOutBound:ToString()
    return LogUtils.ToDetail(self)
end