--- @class ClassBonus_DamageSkillHelper : DamageSkillHelper
ClassBonus_DamageSkillHelper = Class(ClassBonus_DamageSkillHelper, DamageSkillHelper)

--- @return void
--- @param skill BaseSkill
function ClassBonus_DamageSkillHelper:Ctor(skill)
    DamageSkillHelper.Ctor(self, skill)

    --- @type HeroClassType
    self.heroClassType = nil

    --- @type number
    self.skillBonusDamage = nil
end

--- @return void
--- @param heroClassType HeroClassType
--- @param skillBonusDamage number
function ClassBonus_DamageSkillHelper:SetBonusSkillDamage(heroClassType, skillBonusDamage)
    self.heroClassType = heroClassType
    self.skillBonusDamage = skillBonusDamage
end

---------------------------------------- Use Damage skill ----------------------------------------
--- @return UseDamageSkillResult
--- @param target BaseHero
--- @param multiplier number
function ClassBonus_DamageSkillHelper:OnUseDamageSkill(target, multiplier)
    if target.originInfo.class == self.heroClassType then
        multiplier = multiplier * (1 + self.skillBonusDamage)
    end

    return DamageSkillHelper.OnUseDamageSkill(self, target, multiplier)
end