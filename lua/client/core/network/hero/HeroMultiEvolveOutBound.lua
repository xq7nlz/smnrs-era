require "lua.client.core.network.hero.HeroEvolveOutBound"

--- @class HeroMultiEvolveOutBound : OutBound
HeroMultiEvolveOutBound = Class(HeroMultiEvolveOutBound, OutBound)

--- @return void
function HeroMultiEvolveOutBound:Ctor()
    --- @type List
    self.listHeroEvolveOutBound = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroMultiEvolveOutBound:Serialize(buffer)
    buffer:PutByte(self.listHeroEvolveOutBound:Count())
    ---@param v HeroEvolveOutBound
    for i, v in ipairs(self.listHeroEvolveOutBound:GetItems()) do
        v:Serialize(buffer)
    end
end