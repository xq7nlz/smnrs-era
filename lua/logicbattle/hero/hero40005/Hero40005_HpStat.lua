--- @class Hero40005_HpStat
Hero40005_HpStat = Class(Hero40005_HpStat, HpStat)

--- @return void
--- @param hero BaseHero
function Hero40005_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40005_HpStat:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero40005_HpStat:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero40005_HpStat:TakeDamage(initiator, reason, damage)
    if self.skill_4 ~= nil then
        damage = self.skill_4:TakeDamage(initiator, reason, damage)
    end

    damage = HpStat.TakeDamage(self, initiator, reason, damage)
    return damage
end

--- @return boolean
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero40005_HpStat:Dead(initiator, reason)
    local isDead = HpStat.Dead(self, initiator, reason)

    if self.skill_3 ~= nil then
        self.skill_3:OnDead()
    end

    return isDead
end