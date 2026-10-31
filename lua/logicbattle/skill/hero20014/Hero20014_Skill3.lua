--- @class Hero20014_Skill3 Khezzec
Hero20014_Skill3 = Class(Hero20014_Skill3, BaseSkill)

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20014_Skill3:CreateInstance(id, hero)
    return Hero20014_Skill3(id, hero)
end

--- @return void
function Hero20014_Skill3:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    self.myHero.attackController:SetSelector(targetSelector)

    self.myHero.battleHelper:SetBasicAttackMultiplier(self.data.damageAttack)
end

return Hero20014_Skill3