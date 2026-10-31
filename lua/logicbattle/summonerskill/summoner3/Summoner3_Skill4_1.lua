--- @class Summoner3_Skill4_1 : BaseSkill Priest
Summoner3_Skill4_1 = Class(Summoner3_Skill4_1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill4_1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill4_1:CreateInstance(id, hero)
    return Summoner3_Skill4_1(id, hero)
end

--- @return void
function Summoner3_Skill4_1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.powerBuff = self.data.powerBuff

    self.myHero.battleListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Summoner3_Skill4_1:OnStartBattleRound(round)
    if self.data.roundTriggerList:IsContainValue(round.round) then
        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local ally = targetList:Get(i)
            ally.power:Gain(self.myHero, self.powerBuff)
            i = i + 1
        end
    end
end

return Summoner3_Skill4_1