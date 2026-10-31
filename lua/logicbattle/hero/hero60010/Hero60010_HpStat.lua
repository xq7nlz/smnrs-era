--- @class Hero60010_HpStat
Hero60010_HpStat = Class(Hero60010_HpStat, HpStat)

--- @return HpStat
--- @param hero BaseHero
function Hero60010_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60010_HpStat:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return boolean, number isHealOrNot, healAmount
--- @param initiator BaseHero
--- @param reason HealReason
--- @param healAmount number
function Hero60010_HpStat:Heal(initiator, reason, healAmount)
    local canHeal
    canHeal, healAmount = HpStat.Heal(self, initiator, reason, healAmount)

    if self.skill_2 ~= nil then
        self.skill_2:OnHeal(initiator, reason, healAmount)
    end

    return canHeal, healAmount
end