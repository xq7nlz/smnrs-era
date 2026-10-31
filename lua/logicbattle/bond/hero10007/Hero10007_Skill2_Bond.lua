--- @class Hero10007_Skill2_Bond : BaseBond
Hero10007_Skill2_Bond = Class(Hero10007_Skill2_Bond, BaseBond)

--- @return void
--- @param initiator BaseHero
function Hero10007_Skill2_Bond:Ctor(initiator)
    BaseBond.Ctor(self, initiator, BondType.OSSE)
    --- @type number
    self.damagePercent = nil

    --- @type number
    self.ccChance = nil
end

--- @return void
--- @param damagePercent number
function Hero10007_Skill2_Bond:SetInfo(damagePercent, ccChance)
    self.damagePercent = damagePercent
    self.ccChance = ccChance
end

--- @return number
--- @param damageInitiator BaseHero
--- @param target BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero10007_Skill2_Bond:OnTakeDamage(damageInitiator, target, reason, damage)
    if DamageUtils.IsNormalDamage(reason) and self.bondedHeroList:Count() > 0 then
        local shareDamage = damage * self.damagePercent

        for _, bondedHero in pairs(self.bondedHeroList:GetItems()) do
            if bondedHero:IsDead() == false and bondedHero ~= target then
                local result = BondShareDamageResult(target, bondedHero, self.type)
                ActionLogUtils.AddLog(bondedHero.battle, result)

                local bondDamage = bondedHero.hp:TakeDamage(damageInitiator, self:GetTakeDamageReason(reason), shareDamage)

                result:SetDamage(bondDamage)
                result:RefreshHeroStatus()
            end
        end
    end

    return damage
end

--- @return void
--- @param ccEffect BaseEffect
function Hero10007_Skill2_Bond:OnTakeCCEffect(ccEffect)
    local target = ccEffect.myHero
    local initiator = ccEffect.initiator

    local i = 1
    while i <= self.bondedHeroList:Count() do
        local bondedHero = self.bondedHeroList:Get(i)
        if bondedHero:IsDead() == false and bondedHero ~= target then
            if bondedHero.effectController:IsContainEffectType(ccEffect.type) == false then
                if bondedHero.randomHelper:RandomRate(self.ccChance) then
                    local newCCEffect = EffectUtils.CreateCCEffect(initiator, bondedHero, ccEffect.type, ccEffect.duration)
                    bondedHero.effectController:AddEffect(newCCEffect, false)
                end
            end
        end
        i = i + 1
    end
end