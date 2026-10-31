--- @class Hero60009_DamageSkillHelper : DamageSkillHelper
Hero60009_DamageSkillHelper = Class(Hero60009_DamageSkillHelper, DamageSkillHelper)

--- @return void
--- @param skill BaseSkill
function Hero60009_DamageSkillHelper:Ctor(skill)
    DamageSkillHelper.Ctor(self, skill)

    --- @type number
    self.effectType = nil

    --- @type number
    self.skillBonusDamage = nil
end

--- @return void
--- @param effectType EffectType
--- @param skillBonusDamage number
function Hero60009_DamageSkillHelper:SetBonusSkillDamage(effectType, skillBonusDamage)
    self.effectType = effectType
    self.skillBonusDamage = skillBonusDamage
end

---------------------------------------- Use Damage skill ----------------------------------------
--- @return UseDamageSkillResult
--- @param target BaseHero
--- @param multiplier number
function Hero60009_DamageSkillHelper:OnUseDamageSkill(target, multiplier)
    if target.effectController:IsContainEffectType(self.effectType) == true then
        multiplier = multiplier * (1 + self.skillBonusDamage)
    end

    return DamageSkillHelper.OnUseDamageSkill(self, target, multiplier)
end