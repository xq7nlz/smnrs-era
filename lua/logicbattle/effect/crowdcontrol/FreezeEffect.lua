--- @class FreezeEffect : BaseEffect
FreezeEffect = Class(FreezeEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function FreezeEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.FREEZE, false)

    --- @type number damage received when break
    self.damageWhenBreak = EffectConstants.FROZEN_BREAK_DAMAGE * initiator.attack:GetValue()
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function FreezeEffect:OnEffectAdd(target)
    target.effectController.effectListener:Register(EffectListenerType.TAKE_BASIC_ATTACK_DAMAGE, self)
    target.effectController.effectListener:Register(EffectListenerType.TAKE_SKILL_DAMAGE, self)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function FreezeEffect:OnEffectRemove(target)
    target.effectController.effectListener:Unregister(EffectListenerType.TAKE_BASIC_ATTACK_DAMAGE, self)
    target.effectController.effectListener:Unregister(EffectListenerType.TAKE_SKILL_DAMAGE, self)
end

--- @return number delta of damage
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function FreezeEffect:OnBeAttacked(enemyAttacker, totalDamage)
    self:BreakFreeze(enemyAttacker)
    return BaseEffect.OnBeAttacked(self, enemyAttacker, totalDamage)
end

--- @return number delta of damage
--- @param enemy BaseHero
--- @param totalDamage number
function FreezeEffect:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:BreakFreeze(enemy)
    return BaseEffect.OnTakeSkillDamageFromEnemy(self, enemy, totalDamage)
end

--- @return void
--- @param enemy BaseHero
function FreezeEffect:BreakFreeze(enemy)
    local result = BreakFreezeResult(enemy, self.myHero)
    ActionLogUtils.AddLog(self.myHero.battle, result)

    local damage = self.damageWhenBreak * self.duration
    damage = self.myHero.hp:TakeDamage(self.initiator, TakeDamageReason.BREAK_FREEZE, damage)

    result:SetDamage(damage)
    result:RefreshHeroStatus()

    self.isShouldRemove = true
end

--- @return string
function FreezeEffect:ToDetailString()
    return string.format("%s, DAMAGE_WHEN_BREAK = %s", self:ToString(), self.damageWhenBreak)
end