--- @class Hero60003_HpStat
Hero60003_HpStat = Class(Hero60003_HpStat, HpStat)

--- @return HpStat
--- @param hero BaseHero
function Hero60003_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)
    self.skill_3 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60003_HpStat:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero60003_HpStat:TakeDamage(initiator, reason, damage)
    damage = HpStat.TakeDamage(self, initiator, reason, damage)

    if self.skill_3 ~= nil then
        self.skill_3:OnChangeHP(initiator, reason, damage)
    end
    return damage
end

--- @return boolean, number isHealOrNot, healAmount
--- @param initiator BaseHero
--- @param reason HealReason
--- @param healAmount number
function Hero60003_HpStat:Heal(initiator, reason, healAmount)
    local isSuccess, healAmountReal = HpStat.Heal(self, initiator, reason, healAmount)

    if self.skill_3 ~= nil then
        self.skill_3:OnChangeHP(initiator, reason, healAmountReal)
    end
    return isSuccess, healAmountReal
end
