--- @class Hero50014_HpStat
Hero50014_HpStat = Class(Hero50014_HpStat, HpStat)

--- @return void
--- @param hero BaseHero
function Hero50014_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50014_HpStat:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param initiator BaseHero
--- @param reason TakeDamageReason
function Hero50014_HpStat:Dead(initiator, reason)
    HpStat.Dead(self, initiator, reason)

    if self.skill_4 ~= nil then
        self.skill_4:Dead(initiator, reason)
    end
end