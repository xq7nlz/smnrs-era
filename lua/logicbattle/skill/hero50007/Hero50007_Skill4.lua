--- @class Hero50007_Skill4 Celestia
Hero50007_Skill4 = Class(Hero50007_Skill4, BaseSkill)

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50007_Skill4:CreateInstance(id, hero)
    return Hero50007_Skill4(id, hero)
end

--- @return void
function Hero50007_Skill4:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.myHero.attackController:SetSelector(targetSelector)
    self.myHero.battleHelper:SetBasicAttackMultiplier(self.data.damage)
end

return Hero50007_Skill4