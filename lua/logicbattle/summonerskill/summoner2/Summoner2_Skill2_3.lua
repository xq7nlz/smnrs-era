--- @class Summoner2_Skill2_3 : BaseSkill Warrior
Summoner2_Skill2_3 = Class(Summoner2_Skill2_3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner2_Skill2_3:Ctor(id, hero)
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
function Summoner2_Skill2_3:CreateInstance(id, hero)
    return Summoner2_Skill2_3(id, hero)
end

--- @return void
function Summoner2_Skill2_3:Init()
    self.buffChance = self.data.buffChance
    self.statBuffType = self.data.statBuffType
    self.statBuffCalculation = self.data.statBuffCalculation
    self.statBuffAmount = self.data.statBuffAmount

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Summoner2_Skill2_3:OnHeroDead(eventData)
    local target = eventData.target
    if self.myHero:IsAlly(target) and self.listTrigger:IsContainValue(target) == false
            and self.myHero.randomHelper:RandomRate(self.buffChance) then
        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local ally = targetList:Get(i)

            local statBuff = StatChanger(true)
            statBuff:SetInfo(self.statBuffType, self.statBuffCalculation, self.statBuffAmount)

            --- @type BaseEffect
            local effectChanger = StatChangerEffect(self.myHero, ally, true)
            effectChanger:SetPersistentType(EffectPersistentType.LOST_WHEN_DEAD)
            effectChanger:AddStatChanger(statBuff)

            ally.effectController:AddEffect(effectChanger)
            i = i + 1
        end

        self.listTrigger:Add(target)
    end
end

return Summoner2_Skill2_3