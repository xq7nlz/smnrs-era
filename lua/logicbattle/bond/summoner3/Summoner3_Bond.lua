--- @class Summoner3_Bond : BaseBond
Summoner3_Bond = Class(Summoner3_Bond, BaseBond)

--- @return void
--- @param initiator BaseHero
function Summoner3_Bond:Ctor(initiator)
    BaseBond.Ctor(self, initiator, BondType.SUMMONER_3)
end

--- @return number
--- @param damageInitiator BaseHero
--- @param target BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Summoner3_Bond:OnTakeDamage(damageInitiator, target, reason, damage)
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