--- @class Hero40004_HpStat
Hero40004_HpStat = Class(Hero40004_HpStat, HpStat)

--- @return void
--- @param hero BaseHero
function Hero40004_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40004_HpStat:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return boolean
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero40004_HpStat:Dead(initiator, reason)
    local isDead = HpStat.Dead(self, initiator, reason)

    if self.skill_2 ~= nil then
        self.skill_2:Dead(initiator, reason)
    end

    return isDead
end