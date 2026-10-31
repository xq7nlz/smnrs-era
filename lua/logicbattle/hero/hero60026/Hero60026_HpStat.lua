--- @class Hero60026_HpStat
Hero60026_HpStat = Class(Hero60026_HpStat, HpStat)

--- @return HpStat
--- @param hero BaseHero
function Hero60026_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60026_HpStat:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero60026_HpStat:TakeDamage(initiator, reason, damage)
    if self.skill_4 ~= nil then
        damage = self.skill_4:TakeDamage(initiator, reason, damage)
    end

    return HpStat.TakeDamage(self, initiator, reason, damage)
end