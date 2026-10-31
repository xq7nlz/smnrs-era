--- @class Hero10012_Skill4 Assassiren
Hero10012_Skill4 = Class(Hero10012_Skill4, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10012_Skill4:CreateInstance(id, hero)
    return Hero10012_Skill4(id, hero)
end

--- @return void
function Hero10012_Skill4:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)

    self.myHero.skillController.activeSkill:BindingWithSkill_4(self)
end

--- @return EffectPersistentType
function Hero10012_Skill4:GetPersistentDrowningEffect()
    if self.data.drowningMarkCanBeDispelled == true then
        return EffectPersistentType.NON_PERSISTENT
    else
        return EffectPersistentType.EFFECT_SPECIAL_UPDATABLE
    end
end

return Hero10012_Skill4