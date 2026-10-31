--- @class Hero40027_Skill1_Bond : BaseBond
Hero40027_Skill1_Bond = Class(Hero40027_Skill1_Bond, BaseBond)

--- @return void
--- @param initiator BaseHero
function Hero40027_Skill1_Bond:Ctor(initiator, isTarget)
    BaseBond.Ctor(self, initiator, BondType.ARIYUU)

    --- @type number
    self.shareDamagePercent = nil

    self.isTarget = isTarget
end

--- @return void
--- @param damagePercent number
function Hero40027_Skill1_Bond:SetInfo(damagePercent)
    self.shareDamagePercent = damagePercent
end

--- @return number
--- @param damageInitiator BaseHero
--- @param target BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero40027_Skill1_Bond:OnTakeDamage(damageInitiator, target, reason, damage)
    if target == self.initiator and self.initiator:IsDead() == false then
        local damageIsValid = DamageUtils.IsNormalDamage(reason) or DamageUtils.IsInstantKillDamage(reason)
        if damageIsValid == true and self.bondedHeroList:Count() > 0 then
            local shareDamage = damage * self.shareDamagePercent

            for _, bondedHero in pairs(self.bondedHeroList:GetItems()) do
                if bondedHero:IsDead() == false and bondedHero ~= target then
                    local result = BondShareDamageResult(target, bondedHero, self.type)
                    ActionLogUtils.AddLog(bondedHero.battle, result)

                    local bondDamage = bondedHero.hp:TakeDamage(damageInitiator, self:GetTakeDamageReason(reason), shareDamage)
                    result:SetDamage(bondDamage)
                    result:RefreshHeroStatus()
                end
            end

            return damage - shareDamage;
        end
    end

    return damage
end


