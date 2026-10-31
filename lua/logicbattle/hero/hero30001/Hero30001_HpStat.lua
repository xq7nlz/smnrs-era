--- @class Hero30001_HpStat
Hero30001_HpStat = Class(Hero30001_HpStat, HpStat)

function Hero30001_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero30001_HpStat:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return boolean
--- @param initiator BaseHero
--- @param initiator TakeDamageReason
function Hero30001_HpStat:Dead(initiator, reason)
    local isDead = HpStat.Dead(self, initiator, reason)

    if self.skill_4 ~= nil then
        self.skill_4:OnDead()
    end

    return isDead
end
