--- @class RemoteConfigItemOutBound
RemoteConfigItemOutBound = Class(RemoteConfigItemOutBound)

--- @param key string
--- @param valueType RemoteConfigValueType
--- @param value {}
function RemoteConfigItemOutBound:Ctor(key, valueType, value)
    self.key = key
    self.valueType = valueType
    self.value = value
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function RemoteConfigItemOutBound:Serialize(buffer)
    buffer:PutString(self.key, false)
    buffer:PutByte(self.valueType)
    if self.valueType == RemoteConfigValueType.BOOLEAN then
        buffer:PutBool(self.value)
    elseif self.valueType == RemoteConfigValueType.INTEGER then
        buffer:PutInt(self.value)
    elseif self.valueType == RemoteConfigValueType.STRING then
        buffer:PutString(self.value, false)
    elseif self.valueType == RemoteConfigValueType.LONG then
        buffer:PutLong(self.value)
    end
end