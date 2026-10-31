--- @class Summoner3_Skill2_3 : BaseSkill Priest
Summoner3_Skill2_3 = Class(Summoner3_Skill2_3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill2_3:CreateInstance(id, hero)
    return Summoner3_Skill2_3(id, hero)
end

function Summoner3_Skill2_3:Init()
    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    local targetList = targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        target.power:Gain(self.myHero, self.data.powerStat)
        i = i + 1
    end
end

return Summoner3_Skill2_3