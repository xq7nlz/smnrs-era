--- @class Summoner3_Skill3_2 : BaseSkill Priest
Summoner3_Skill3_2 = Class(Summoner3_Skill3_2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill3_2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner3_Skill3_2:CreateInstance(id, hero)
    return Summoner3_Skill3_2(id, hero)
end

--- @return void
function Summoner3_Skill3_2:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount
    self.statBuffDuration = self.data.statBuffDuration

    self.myHero.battleListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Summoner3_Skill3_2:OnStartBattleRound(round)
    if self.data.roundTriggerList:IsContainValue(round.round) then
        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local ally = targetList:Get(i)
            local statBuff = StatChanger(true)
            statBuff:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

            --- @type BaseEffect
            local effectChanger = StatChangerEffect(self.myHero, ally, true)
            effectChanger:SetDuration(self.statBuffDuration)
            effectChanger:AddStatChanger(statBuff)
            effectChanger:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
            ally.effectController:AddEffect(effectChanger)
            i = i + 1
        end
    end
end

return Summoner3_Skill3_2