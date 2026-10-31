--- @class Hero40002_Skill4 Yggra
Hero40002_Skill4 = Class(Hero40002_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40002_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.hpLimit = nil
    --- @type number
    self.triggerLimit = nil
    --- @type number
    self.triggerNumber = 0

    --- @type BaseTargetSelector
    self.statBuffTargetSelector = nil

    --- @type number
    self.statBuffDuration = nil

    --- @type StatType
    self.statBuffType_1 = nil
    --- @type number
    self.statBuffAmount_1 = nil

    --- @type StatType
    self.statBuffType_2 = nil
    --- @type number
    self.statBuffAmount_2 = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40002_Skill4:CreateInstance(id, hero)
    return Hero40002_Skill4(id, hero)
end

--- @return void
function Hero40002_Skill4:Init()
    self.hpLimit = self.data.hpLimit
    self.triggerLimit = self.data.triggerLimit
    self.statBuffDuration = self.data.statBuffDuration

    self.statBuffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.statBuffType_1 = self.data.statBuffType_1
    self.statBuffAmount_1 = self.data.statBuffAmount_1

    self.statBuffType_2 = self.data.statBuffType_2
    self.statBuffAmount_2 = self.data.statBuffAmount_2

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param eventData table
function Hero40002_Skill4:OnHpChange(eventData)
    if self.myHero:IsDead() == false then
        local target = eventData.target
        if target == self.myHero and self.triggerNumber < self.triggerLimit and self.myHero.hp:GetStatPercent() <= self.hpLimit then
            self.triggerNumber = self.triggerNumber + 1
            self:TriggerSkill()
        end
    end
end

--- @return void
function Hero40002_Skill4:TriggerSkill()
    local targetList = self.statBuffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)

        local statChanger_1 = StatChanger(true)
        statChanger_1:SetInfo(self.statBuffType_1, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount_1)

        local statChanger_2 = StatChanger(true)
        statChanger_2:SetInfo(self.statBuffType_2, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount_2)

        local effect = StatChangerEffect(self.myHero, target, true)
        effect:SetDuration(self.statBuffDuration)
        effect:AddStatChanger(statChanger_1)
        effect:AddStatChanger(statChanger_2)

        target.effectController:AddEffect(effect)
        i = i + 1
    end
end

return Hero40002_Skill4