require "lua.client.core.network.event.MaterialExchangeOutBound"

--- @class ExchangeOutBound : OutBound
ExchangeOutBound = Class(ExchangeOutBound, OutBound)

--- @return void
function ExchangeOutBound:Ctor(id)
    ---@type number
    self.id = id
    ---@type List
    self.listMaterials = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ExchangeOutBound:Serialize(buffer)
    buffer:PutInt(self.id)
    buffer:PutByte(self.listMaterials:Count())
    ---@param v MaterialExchangeOutBound
    for _, v in ipairs(self.listMaterials:GetItems()) do
        v:Serialize(buffer)
    end
end 