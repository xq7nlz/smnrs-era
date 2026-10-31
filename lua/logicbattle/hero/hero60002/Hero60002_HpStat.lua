--- @class Hero60002_HpStat
Hero60002_HpStat = Class(Hero60002_HpStat, HpStat)

--- @return void
--- @param hero BaseHero
function Hero60002_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil

    --- @type BaseSkill
    self.skill_3 = nil

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60002_HpStat:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param skill BaseSkill
function Hero60002_HpStat:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param skill BaseSkill
function Hero60002_HpStat:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return boolean
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero60002_HpStat:Dead(initiator, reason)
    local isDead = HpStat.Dead(self, initiator, reason)

    if self.skill_2 ~= nil then
        self.skill_2:OnDead(initiator, reason)
    end

    if self.skill_3 ~= nil then
        self.skill_3:OnDead(initiator, reason)
    end

    if self.skill_4 ~= nil then
        self.skill_4:OnDead(initiator, reason)
    end

    return isDead
end