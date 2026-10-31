--- @class Hero20008_HpStat
Hero20008_HpStat = Class(Hero20008_HpStat, HpStat)

--- @return void
--- @param hero BaseHero
function Hero20008_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero20008_HpStat:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return boolean
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero20008_HpStat:Dead(initiator, reason)
    local isDead = HpStat.Dead(self, initiator, reason)

    if self.skill_2 ~= nil then
        self.skill_2:Dead(initiator, reason)
    end

    return isDead
end