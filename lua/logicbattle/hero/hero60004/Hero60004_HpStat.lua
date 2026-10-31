--- @class Hero60004_HpStat
Hero60004_HpStat = Class(Hero60004_HpStat, HpStat)

--- @return void
--- @param hero BaseHero
function Hero60004_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero60004_HpStat:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero60004_HpStat:TakeDamage(initiator, reason, damage)
    if self.skill_3 ~= nil then
        damage = self.skill_3:GetReduceDamage(initiator, reason, damage)
    end
    return HpStat.TakeDamage(self, initiator, reason, damage)
end