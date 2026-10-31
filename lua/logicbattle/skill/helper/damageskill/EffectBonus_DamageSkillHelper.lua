--- @class EffectBonus_DamageSkillHelper : DamageSkillHelper
EffectBonus_DamageSkillHelper = Class(EffectBonus_DamageSkillHelper, DamageSkillHelper)

--- @return void
--- @param skill BaseSkill
function EffectBonus_DamageSkillHelper:Ctor(skill)
    DamageSkillHelper.Ctor(self, skill)

    --- @type number
    self.effectType = nil

    --- @type number
    self.skillBonusDamage = nil
end

--- @return void
--- @param effectType EffectType
--- @param skillBonusDamage number
function EffectBonus_DamageSkillHelper:SetBonusSkillDamage(effectType, skillBonusDamage)
    self.effectType = effectType
    self.skillBonusDamage = skillBonusDamage
end

---------------------------------------- Use Damage skill ----------------------------------------
--- @return UseDamageSkillResult
--- @param target BaseHero
--- @param multiplier number
function EffectBonus_DamageSkillHelper:OnUseDamageSkill(target, multiplier)
    if target.effectController:IsContainEffectType(self.effectType) == true then
        multiplier = multiplier * (1 + self.skillBonusDamage)
    end

    return DamageSkillHelper.OnUseDamageSkill(self, target, multiplier)
end