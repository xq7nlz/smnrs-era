--- @class CurseMarkEffect : BaseEffect
--- remove buff and not receive buff
CurseMarkEffect = Class(CurseMarkEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function CurseMarkEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.CURSE_MARK, false)
    self.persistentType = EffectPersistentType.NON_PERSISTENT_NOT_DISPELLABLE
end

function CurseMarkEffect:IsTrigger(type)
    return true
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function CurseMarkEffect:OnEffectRemove(target)
    if self.myHero:IsDead() == true then
        self.myHero.hp:SetCanRevive(false)
    end
end