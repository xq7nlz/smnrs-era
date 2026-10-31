--- @class Hero30002_HpStat
Hero30002_HpStat = Class(Hero30002_HpStat, HpStat)

--- @return void
--- @param hero BaseHero
function Hero30002_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil

    --- @type TakeDamageReason
    self.reason = nil
end

--- @return void
--- @param skill BaseSkill
function Hero30002_HpStat:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero30002_HpStat:TakeDamage(initiator, reason, damage)
    self.reason = reason

    if self.skill_3 ~= nil then
        damage = self.skill_3:TakeDamage(initiator, reason, damage)
    end

    return HpStat.TakeDamage(self, initiator, reason, damage)
end