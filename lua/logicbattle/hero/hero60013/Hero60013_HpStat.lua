--- @class Hero60013_HpStat
Hero60013_HpStat = Class(Hero60013_HpStat, HpStat)

--- @return void
--- @param hero BaseHero
function Hero60013_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)
    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60013_HpStat:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return boolean
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero60013_HpStat:Dead(initiator, reason)
    local isDead = HpStat.Dead(self, initiator, reason)

    if self.skill_4 ~= nil then
        self.skill_4:OnDead(initiator, reason)
    end

    return isDead
end