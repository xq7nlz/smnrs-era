--- @class BlessMarkEffect : BaseEffect
--- not receive debuff
BlessMarkEffect = Class(BlessMarkEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function BlessMarkEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.BLESS_MARK, true)
    self.persistentType = EffectPersistentType.NON_PERSISTENT_NOT_DISPELLABLE
end

function BlessMarkEffect:IsTrigger(type)
    return true
end