--- @class Summoner_3_BlessMarkEffect : BaseEffect
--- not receive debuff
Summoner_3_BlessMarkEffect = Class(Summoner_3_BlessMarkEffect, BlessMarkEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function Summoner_3_BlessMarkEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.BLESS_MARK, true)
    self:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)
end

--- @return void
--- for updating duration
function Summoner_3_BlessMarkEffect:UpdateAfterRound()
    self:DecreaseDuration()
end