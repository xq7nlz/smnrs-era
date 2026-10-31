--- @class Hero40006_HpStat
Hero40006_HpStat = Class(Hero40006_HpStat, HpStat)

--- @return void
--- @param hero BaseHero
function Hero40006_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40006_HpStat:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return boolean
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero40006_HpStat:Dead(initiator, reason)
    local isDead = HpStat.Dead(self, initiator, reason)

    if self.skill_3 ~= nil then
        self.skill_3:OnDead()
    end

    return isDead
end