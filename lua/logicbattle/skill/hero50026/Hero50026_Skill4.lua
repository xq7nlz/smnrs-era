--- @class Hero50026_Skill4 Fioneth
Hero50026_Skill4 = Class(Hero50026_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50026_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.hpLimit = nil
    --- @type number
    self.triggerLimit = nil
    --- @type number
    self.triggerNumber = 0

    --- @type StatType
    self.statBuffType = nil
    --- @type BaseTargetSelector
    self.statBuffTargetSelector = nil
    --- @type number
    self.statBuffDuration = nil
    --- @type number
    self.statBuffAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @param hero BaseHero
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50026_Skill4:CreateInstance(id, hero)
    return Hero50026_Skill4(id, hero)
end

--- @return void
function Hero50026_Skill4:Init()
    self.hpLimit = self.data.hpLimit
    self.triggerLimit = self.data.triggerLimit

    self.statBuffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.statBuffTargetPosition,
            TargetTeamType.ALLY, self.data.statBuffTargetNumber)

    self.statBuffDuration = self.data.statBuffDuration
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param eventData table
function Hero50026_Skill4:OnHpChange(eventData)
    if self.myHero:IsDead() == false then
        local target = eventData.target
        if target == self.myHero and self.triggerNumber < self.triggerLimit and self.myHero.hp:GetStatPercent() <= self.hpLimit then
            self.triggerNumber = self.triggerNumber + 1
            self:TriggerSkill()
        end
    end
end

--- @return void
function Hero50026_Skill4:TriggerSkill()
    local allyTargetList = self.statBuffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= allyTargetList:Count() do
        local target = allyTargetList:Get(i)
        local statChanger = StatChanger(true)
        statChanger:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

        local effect = StatChangerEffect(self.myHero, target, true)
        effect:SetDuration(self.statBuffDuration)
        effect:AddStatChanger(statChanger)

        target.effectController:AddEffect(effect)
        i = i + 1
    end
end

return Hero50026_Skill4