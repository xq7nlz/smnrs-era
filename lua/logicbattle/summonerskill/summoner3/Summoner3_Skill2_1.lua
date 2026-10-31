--- @class Summoner3_Skill2_1 : BaseSkill Priest
Summoner3_Skill2_1 = Class(Summoner3_Skill2_1, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill2_1:CreateInstance(id, hero)
    return Summoner3_Skill2_1(id, hero)
end

--- @return void
function Summoner3_Skill2_1:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)

    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    local targetList = targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        statChangerSkillHelper:AddStatChangerEffect(self.myHero, target)
        i = i + 1
    end
end

return Summoner3_Skill2_1