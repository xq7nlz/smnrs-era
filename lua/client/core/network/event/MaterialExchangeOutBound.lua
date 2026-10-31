
--- @class MaterialExchangeOutBound : OutBound
MaterialExchangeOutBound = Class(MaterialExchangeOutBound, OutBound)

--- @return void
function MaterialExchangeOutBound:Ctor(type)
    ---@type number
    self.type = type
    ---@type List
    self.listHero = nil
    ---@type Dictionary
    self.dictEquipment = nil
    ---@type Dictionary
    self.dictArtifact = nil
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function MaterialExchangeOutBound:Serialize(buffer)
    buffer:PutByte(self.type)
    if self.type == 0 then
        buffer:PutByte(self.listHero:Count())
        for _, id in ipairs(self.listHero:GetItems()) do
            buffer:PutLong(id)
        end
    elseif self.type == 1 then
        buffer:PutByte(self.dictEquipment:Count())
        for id, number in pairs(self.dictEquipment:GetItems()) do
            buffer:PutInt(id)
            buffer:PutInt(number)
        end
    elseif self.type == 2 then
        buffer:PutByte(self.dictArtifact:Count())
        for id, number in pairs(self.dictArtifact:GetItems()) do
            buffer:PutInt(id)
            buffer:PutInt(number)
        end
    end
end 