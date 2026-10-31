--- @class Summoner1_Skill3_2 : BaseSkill Mage
Summoner1_Skill3_2 = Class(Summoner1_Skill3_2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner1_Skill3_2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner1_Skill3_2:CreateInstance(id, hero)
    return Summoner1_Skill3_2(id, hero)
end

--- @return void
function Summoner1_Skill3_2:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.buffDuration = self.data.buffDuration
    self.buffChance = self.data.buffChance

    self.statBuffType_1 = self.data.statBuffType_1
    self.statBuffCalculation_1 = self.data.statBuffCalculation_1
    self.statBuffAmount_1 = self.data.statBuffAmount_1

    self.statBuffType_2 = self.data.statBuffType_2
    self.statBuffCalculation_2 = self.data.statBuffCalculation_2
    self.statBuffAmount_2 = self.data.statBuffAmount_2

    self.myHero.battleListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Summoner1_Skill3_2:OnStartBattleRound(round)
    if self.myHero.randomHelper:RandomRate(self.buffChance) and self.data.roundTriggerList:IsContainValue(round.round) then
        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local ally = targetList:Get(i)
            local statBuff_1 = StatChanger(true)
            statBuff_1:SetInfo(self.statBuffType_1, self.statBuffCalculation_1, self.statBuffAmount_1)

            local statBuff_2 = StatChanger(true)
            statBuff_2:SetInfo(self.statBuffType_2, self.statBuffCalculation_2, self.statBuffAmount_2)

            local effect = StatChangerEffect(self.myHero, ally, true)
            effect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
            effect:SetDuration(self.buffDuration)

            effect:AddStatChanger(statBuff_1)
            effect:AddStatChanger(statBuff_2)
            ally.effectController:AddEffect(effect)
            i = i + 1
        end
    end
end

return Summoner1_Skill3_2