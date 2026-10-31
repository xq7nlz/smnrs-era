--- @class Hero30006_DamageSkillHelper : DamageSkillHelper
Hero30006_DamageSkillHelper = Class(Hero30006_DamageSkillHelper, DamageSkillHelper)

--- @return void
--- @param skill BaseSkill
function Hero30006_DamageSkillHelper:Ctor(skill)
    DamageSkillHelper.Ctor(self, skill)

    --- @type number
    self.targetHpLimit = nil

    --- @type number
    self.skillBonusDamage = nil
end

--- @return void
--- @param targetHpLimit number
--- @param skillBonusDamage number
function Hero30006_DamageSkillHelper:SetBonusSkillDamage(targetHpLimit, skillBonusDamage)
    self.targetHpLimit = targetHpLimit
    self.skillBonusDamage = skillBonusDamage
end

---------------------------------------- Use Damage skill ----------------------------------------
--- @return UseDamageSkillResult
--- @param target BaseHero
--- @param multiplier number
function Hero30006_DamageSkillHelper:OnUseDamageSkill(target, multiplier)
    if target.hp:GetStatPercent() < self.targetHpLimit then
        multiplier = multiplier * (1 + self.skillBonusDamage)
    end

    return DamageSkillHelper.OnUseDamageSkill(self, target, multiplier)
end