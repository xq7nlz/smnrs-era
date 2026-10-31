--- @class Hero60014_Skill1_Bond : BaseBond
Hero60014_Skill1_Bond = Class(Hero60014_Skill1_Bond, BaseBond)

--- @return void
--- @param initiator BaseHero
function Hero60014_Skill1_Bond:Ctor(initiator)
    BaseBond.Ctor(self, initiator, BondType.SHISHIL)
end

--- @return number
--- @param damageInitiator BaseHero
--- @param target BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero60014_Skill1_Bond:OnTakeDamage(damageInitiator, target, reason, damage)
    if reason == TakeDamageReason.ATTACK_DAMAGE or reason == TakeDamageReason.SKILL_DAMAGE
            and self.bondedHeroList:Count() > 0 then
        local sharedDamage = damage / self.bondedHeroList:Count()

        for _, bondedHero in pairs(self.bondedHeroList:GetItems()) do
            if bondedHero:IsDead() == false and target ~= bondedHero then
                local result = BondShareDamageResult(target, bondedHero, self.type)
                ActionLogUtils.AddLog(target.battle, result)

                local bondDamage = sharedDamage
                bondDamage = bondedHero.hp:TakeDamage(damageInitiator, self:GetTakeDamageReason(reason), bondDamage)

                result:SetDamage(bondDamage)
                result:RefreshHeroStatus()
            end
        end

        return sharedDamage
    end
    return damage
end