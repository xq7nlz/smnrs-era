--- @class Summoner5_Skill3_2 : BaseSkill Ranger
Summoner5_Skill3_2 = Class(Summoner5_Skill3_2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner5_Skill3_2:CreateInstance(id, hero)
    return Summoner5_Skill3_2(id, hero)
end

--- @return void
function Summoner5_Skill3_2:Init()
    self.debuffStatChangerSkillHelper = StatChangerSkillHelper(self, self.data.debuffBonuses)
    self.debuffStatChangerSkillHelper:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
    self.debuffStatChangerSkillHelper:SetInfo(false, self.data.debuffDuration)

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.myHero.battleListener:BindingWithSkill3_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Summoner5_Skill3_2:OnStartBattleRound(round)
    if self.data.roundTriggerList:IsContainValue(round.round) then
        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            self.debuffStatChangerSkillHelper:AddStatChangerEffect(self.myHero, target)
            i = i + 1
        end
    end
end

return Summoner5_Skill3_2