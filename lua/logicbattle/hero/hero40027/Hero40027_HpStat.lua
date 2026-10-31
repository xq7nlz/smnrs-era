--- @class Hero40027_HpStat : HpStat
Hero40027_HpStat = Class(Hero40027_HpStat, HpStat)

--- @return void
--- @param hero BaseHero
function Hero40027_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type Hero40027_Skill4
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40027_HpStat:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero40027_HpStat:OnTakeDamage(initiator, reason, damage)
    damage = HpStat.OnTakeDamage(self, initiator, reason, damage)

    if self.skill_4 ~= nil then
        damage = self.skill_4:OnTakeDamage(damage)
    end

    return damage
end

--- @return void
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero40027_HpStat:OnAfterTakeDamage(initiator, reason, damage)
    if self.skill_4 ~= nil then
        damage = self.skill_4:OnAfterTakeDamage()
    end
end


