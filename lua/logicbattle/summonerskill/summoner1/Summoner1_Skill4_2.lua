--- @class Summoner1_Skill4_2 : BaseSkill Mage
Summoner1_Skill4_2 = Class(Summoner1_Skill4_2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner1_Skill4_2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner1_Skill4_2:CreateInstance(id, hero)
    return Summoner1_Skill4_2(id, hero)
end

--- @return void
function Summoner1_Skill4_2:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.powerBuff = self.data.powerBuff

    self.myHero.battleListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Summoner1_Skill4_2:OnStartBattleRound(round)
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local ally = targetList:Get(i)
        ally.power:Gain(self.myHero, self.powerBuff)
        i = i + 1
    end
end

return Summoner1_Skill4_2