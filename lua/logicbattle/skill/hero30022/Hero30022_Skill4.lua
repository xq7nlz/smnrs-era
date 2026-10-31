--- @class Hero30022_Skill4 Dungan
Hero30022_Skill4 = Class(Hero30022_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30022_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30022_Skill4:CreateInstance(id, hero)
    return Hero30022_Skill4(id, hero)
end

--- @return void
function Hero30022_Skill4:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)
    self.myHero.attackController:SetSelector(targetSelector)
    self.myHero.battleHelper:SetBasicAttackMultiplier(self.data.damage)
end

return Hero30022_Skill4