--- @class HeroEvolveOrbOutBound : OutBound
HeroEvolveOrbOutBound = Class(HeroEvolveOrbOutBound, OutBound)

--- @return void
function HeroEvolveOrbOutBound:Ctor(slotId, orbType, number)
    --- @type number
    self.slotId = slotId
    --- @type MoneyType
    self.orbType = orbType
    --- @type number
    self.number = number
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroEvolveOrbOutBound:Serialize(buffer)
    buffer:PutByte(self.slotId)
    buffer:PutInt(self.orbType)
    buffer:PutInt(self.number)
end