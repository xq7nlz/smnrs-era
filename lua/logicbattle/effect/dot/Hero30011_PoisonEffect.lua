--- @class Hero30011_PoisonEffect : DotEffect
Hero30011_PoisonEffect = Class(Hero30011_PoisonEffect, DotEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param skillId number
function Hero30011_PoisonEffect:Ctor(initiator, target, skillId)
    DotEffect.Ctor(self, initiator, target, EffectType.POISON)

    --- @type number
    self.skillId = skillId
end

--- @return PoisonEffectResult
function Hero30011_PoisonEffect:CreateEffectResult()
    return PoisonEffectResult(self.initiator, self.myHero, self.duration)
end

--- @return boolean
function Hero30011_PoisonEffect:GetPoisonSkillId()
    return self.skillId
end

--- @return void
--- @param target BaseHero
function Hero30011_PoisonEffect:OnEffectAdd(target)
    local result = self:CreateEffectResult()
    ActionLogUtils.AddLog(self.myHero.battle, result)

    local totalDamage = self.myHero.hp:TakeDamage(self.initiator, self:GetTakeDamageReason(), self.amount)

    result:SetDamage(totalDamage)
    result:RefreshHeroStatus()
end

--- @return void
function Hero30011_PoisonEffect:UpdateBeforeRound()
    if self.myHero:IsDead() == false then
        local result = self:CreateEffectResult()
        ActionLogUtils.AddLog(self.myHero.battle, result)

        local totalDamage = self.myHero.hp:TakeDamage(self.initiator, self:GetTakeDamageReason(), self.amount)

        result:SetDamage(totalDamage)
        result:RefreshHeroStatus()
    end
end

--- @return TakeDamageReason
function Hero30011_PoisonEffect:GetTakeDamageReason()
    return TakeDamageReason.POISON
end

