require "lua.client.core.network.playerData.unknown.PutMethod"


--- @class DictionaryOutBound : OutBound
DictionaryOutBound = Class(DictionaryOutBound, OutBound)

--- @return void
function DictionaryOutBound:Ctor()
    --- @type List -- number
    self.dictionary = Dictionary()
end

function DictionaryOutBound.CreateInstance(_dictionary)
    local inst = DictionaryOutBound()
    inst:SetData(_dictionary)
    return inst
end

function DictionaryOutBound:SetData(_dictionary)
    --- @type {}
    self.dictionary = _dictionary
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function DictionaryOutBound:Serialize(buffer)
    buffer:PutByte(self.dictionary:Count())
    for k, v in pairs(self.dictionary:GetItems()) do
        buffer:PutInt(k)
        buffer:PutInt(v)
    end
end