--- @class HandShakeOutBound : OutBound
HandShakeOutBound = Class(HandShakeOutBound, OutBound)

--- @return void
--- @param sharedSecret string
function HandShakeOutBound:Ctor(sharedSecret)
    assert(sharedSecret)
    --- @type number
    self.clientTime = os.time()
    --- @type string
    self.clientChallenge = SHA2.shaHex256(string.format("%s%d", sharedSecret, self.clientTime))
    --- @type string
    self.clientVersion = PRODUCT_VERSION
    --- @type string
    self.clientBundleName = U_Application.identifier
    --- @type number
    self.osOfClient = ClientConfigUtils.GetDeviceOS()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HandShakeOutBound:Serialize(buffer)
    buffer:PutString(self.clientChallenge, false)
    buffer:PutLong(self.clientTime)
    buffer:PutString(self.clientVersion, false)
    buffer:PutString(self.clientBundleName, false)
    buffer:PutByte(self.osOfClient)
    buffer:PutInt(GOOGLE_SCRIPT.numberFiles)
    buffer:PutString(GOOGLE_SCRIPT.hash, false)
end

--- @return void
function HandShakeOutBound:ToString()
    return string.format("ClientChallenge[%s] Time[%s] Version[%s] Bundle[%s] Os[%s]",
        self.clientChallenge, self.clientTime, self.clientVersion, self.clientBundleName, self.osOfClient)
end