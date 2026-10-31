--- @class Hero10006_Skill2_Bond : BaseBond
Hero10006_Skill2_Bond = Class(Hero10006_Skill2_Bond, BaseBond)

--- @return void
--- @param initiator BaseHero
function Hero10006_Skill2_Bond:Ctor(initiator)
    BaseBond.Ctor(self, initiator, BondType.AQUALORD)

    --- @type number
    self.shareDamagePercent = nil
end

--- @return void
--- @param damagePercent number
function Hero10006_Skill2_Bond:SetShareDamagePercent(damagePercent)
    self.shareDamagePercent = damagePercent
end

--- @return number
--- @param damageInitiator BaseHero
--- @param target BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero10006_Skill2_Bond:OnTakeDamage(damageInitiator, target, reason, damage)
    --- Only share damage if target is not the one that created bond
    if target ~= self.initiator then
        if self.initiator:IsDead() == false then
            local result = BondShareDamageResult(target, self.initiator, self.type)
            ActionLogUtils.AddLog(target.battle, result)

            local bondDamage = damage * self.shareDamagePercent
            bondDamage = self.initiator.hp:TakeDamage(damageInitiator, self:GetTakeDamageReason(reason), bondDamage)

            result:SetDamage(bondDamage)
            result:RefreshHeroStatus()

            return damage * (1 - self.shareDamagePercent)
        end
    end

    return damage
end