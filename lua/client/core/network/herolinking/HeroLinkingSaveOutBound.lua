require "lua.client.core.network.heroLinking.BindingHeroInBound"

--- @class HeroLinkingSaveOutBound : OutBound
HeroLinkingSaveOutBound = Class(HeroLinkingSaveOutBound, OutBound)

--- @return void
function HeroLinkingSaveOutBound:Ctor(groupId)
    self.groupId = groupId
    self.slotDict = Dictionary()
end

--- @param slotId number
--- @param bindingHeroInBound BindingHeroInBound
function HeroLinkingSaveOutBound:SetSlot(slotId, bindingHeroInBound)
    self.slotDict:Add(slotId, bindingHeroInBound)
end

--- @param slotId number
function HeroLinkingSaveOutBound:RemoveSlot(slotId)
    self.slotDict:RemoveByKey(slotId)
end

--- @param buffer UnifiedNetwork_ByteBuf
function HeroLinkingSaveOutBound:Serialize(buffer)
    buffer:PutInt(self.groupId)
    buffer:PutByte(self.slotDict:Count())
    --- @param v BindingHeroInBound
    for k, v in pairs(self.slotDict:GetItems()) do
        buffer:PutByte(k)
        v:Serialize(buffer)
    end
end