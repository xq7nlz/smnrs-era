--- @class Hero30010_Skill4 Erde
Hero30010_Skill4 = Class(Hero30010_Skill4, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30010_Skill4:CreateInstance(id, hero)
    return Hero30010_Skill4(id, hero)
end

--- @return void
function Hero30010_Skill4:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    local targetList = targetSelector:SelectTarget(self.myHero.battle)

    local aura = Hero30010_Skill4_Aura(self.myHero, self)
    aura:SetTarget(targetList, TargetTeamType.ALLY)

    self.auraSkillHelper = MagicShieldAuraSkillHelper(self, aura, self.data.blockChance, self.data.blockRate)
    self.auraSkillHelper:Init()
    self.auraSkillHelper:StartAura()
end

return Hero30010_Skill4