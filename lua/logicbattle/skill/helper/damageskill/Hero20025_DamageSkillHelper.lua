--- @class Hero20025_DamageSkillHelper : DamageSkillHelper
Hero20025_DamageSkillHelper = Class(Hero20025_DamageSkillHelper, DamageSkillHelper)

--- @return void
--- @param skill BaseSkill
function Hero20025_DamageSkillHelper:Ctor(skill)
    DamageSkillHelper.Ctor(self, skill)

    --- @type number
    self.targetHpLimit = nil

    --- @type number
    self.skillBonusDamage = nil
end

--- @return void
--- @param targetHpLimit number
--- @param skillBonusDamage number
function Hero20025_DamageSkillHelper:SetBonusSkillDamage(targetHpLimit, skillBonusDamage)
    self.targetHpLimit = targetHpLimit
    self.skillBonusDamage = skillBonusDamage
end

---------------------------------------- Use Damage skill ----------------------------------------
--- @return UseDamageSkillResult
--- @param target BaseHero
--- @param multiplier number
function Hero20025_DamageSkillHelper:OnUseDamageSkill(target, multiplier)
    if target.hp:GetStatPercent() > self.targetHpLimit then
        multiplier = multiplier * (1 + self.skillBonusDamage)
    end

    return DamageSkillHelper.OnUseDamageSkill(self, target, multiplier)
end