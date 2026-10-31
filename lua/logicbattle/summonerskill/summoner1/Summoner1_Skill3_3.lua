--- @class Summoner1_Skill3_3 : BaseSkill Mage
Summoner1_Skill3_3 = Class(Summoner1_Skill3_3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner1_Skill3_3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type BaseTargetSelector
    self.targetSelector = nil

    ---@type List List<BaseHero>
    self.listTrigger = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner1_Skill3_3:CreateInstance(id, hero)
    return Summoner1_Skill3_3(id, hero)
end

--- @return void
function Summoner1_Skill3_3:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.buffChance = self.data.buffChance
    self.statBuffType_1 = self.data.statBuffType_1
    self.statBuffCalculation_1 = self.data.statBuffCalculation_1
    self.statBuffAmount_1 = self.data.statBuffAmount_1

    self.statBuffType_2 = self.data.statBuffType_2
    self.statBuffCalculation_2 = self.data.statBuffCalculation_2
    self.statBuffAmount_2 = self.data.statBuffAmount_2

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Summoner1_Skill3_3:OnHeroDead(eventData)
    local target = eventData.target
    if self.myHero:IsAlly(target) and self.listTrigger:IsContainValue(target) == false
            and self.myHero.randomHelper:RandomRate(self.buffChance) then
        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local ally = targetList:Get(i)

            local statBuff_1 = StatChanger(true)
            statBuff_1:SetInfo(self.statBuffType_1, self.statBuffCalculation_1, self.statBuffAmount_1)

            local statBuff_2 = StatChanger(true)
            statBuff_2:SetInfo(self.statBuffType_2, self.statBuffCalculation_2, self.statBuffAmount_2)

            --- @type BaseEffect
            local effectChanger = StatChangerEffect(self.myHero, ally, true)
            effectChanger:SetPersistentType(EffectPersistentType.LOST_WHEN_DEAD)
            effectChanger:AddStatChanger(statBuff_1)
            effectChanger:AddStatChanger(statBuff_2)

            ally.effectController:AddEffect(effectChanger)
            i = i + 1
        end

        self.listTrigger:Add(target)
    end
end

return Summoner1_Skill3_3