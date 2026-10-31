--- @class Hero10008_HpStat
Hero10008_HpStat = Class(Hero10008_HpStat, HpStat)

--- @return HpStat
--- @param hero BaseHero
function Hero10008_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero10008_HpStat:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return boolean
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero10008_HpStat:Dead(initiator, reason)
    local isDead = HpStat.Dead(self, initiator, reason)

    if self.skill_2 ~= nil then
        self.skill_2:OnDead(initiator, reason)
    end

    return isDead
end