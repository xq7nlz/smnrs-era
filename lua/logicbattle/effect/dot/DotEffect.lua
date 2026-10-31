--- @class DotEffect : BaseEffect
DotEffect = Class(DotEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param effectType EffectType
function DotEffect:Ctor(initiator, target, effectType)
    BaseEffect.Ctor(self, initiator, target, effectType, false)

    --- @type number
    self.amount = nil
end

--- @return void
--- @param amount number
function DotEffect:SetDotAmount(amount)
    self.amount = amount
end

--- @return DotEffectResult
function DotEffect:CreateEffectResult()
    assert(false, "this method should be overridden by child class")
end

--- @return TakeDamageReason
function DotEffect:GetTakeDamageReason()
    assert(false, "this method should be overridden by child class")
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
function DotEffect:OnEffectAdd(target)
    local result = self:CreateEffectResult()
    ActionLogUtils.AddLog(self.myHero.battle, result)

    local takeDamageReason = self:GetTakeDamageReason()
    local totalDamage, isCrit, dodgeType, isBlock = self.initiator.battleHelper:CalculateDotEffectResult(self.myHero, self.amount, takeDamageReason)
    totalDamage = self.myHero.hp:TakeDamage(self.initiator, takeDamageReason, totalDamage)

    result:SetDamage(totalDamage)
    result:RefreshHeroStatus()
end

--- @return void
function DotEffect:UpdateBeforeRound()
    if self.myHero:IsDead() == false then
        local result = self:CreateEffectResult()
        ActionLogUtils.AddLog(self.myHero.battle, result)

        local takeDamageReason = self:GetTakeDamageReason()
        local totalDamage, isCrit, dodgeType, isBlock = self.initiator.battleHelper:CalculateDotEffectResult(self.myHero, self.amount, takeDamageReason)
        totalDamage = self.myHero.hp:TakeDamage(self.initiator, takeDamageReason, totalDamage)

        result:SetDamage(totalDamage)
        result:RefreshHeroStatus()
    end
end

--- @return string
function DotEffect:ToDetailString()
    return string.format("%s, DOT_AMOUNT = %s", self:ToString(), self.amount)
end
