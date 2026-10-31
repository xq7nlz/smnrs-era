--- @class Hero30003_HpStat
Hero30003_HpStat = Class(Hero30003_HpStat, HpStat)

--- @return void
--- @param hero BaseHero
function Hero30003_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero30003_HpStat:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return boolean, number isHealOrNot, healAmount
--- @param initiator BaseHero
--- @param reason HealReason
--- @param healAmount number
function Hero30003_HpStat:Heal(initiator, reason, healAmount)
    if self.skill_2 ~= nil then
        if self.skill_2:CanHeal(initiator) then
            return HpStat.Heal(self, initiator, reason, healAmount)
        end
    end

    return false, 0
end