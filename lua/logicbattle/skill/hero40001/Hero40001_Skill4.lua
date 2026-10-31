--- @class Hero40001_Skill4 Tilion
Hero40001_Skill4 = Class(Hero40001_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40001_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.hpLimit = nil
    --- @type number
    self.triggerLimit = nil
    --- @type number
    self.triggerNumber = 0
    --- @type number
    self.triggerChance = nil

    --- @type BaseTargetSelector
    self.effectTargetSelector = nil
    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectDuration = nil

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
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40001_Skill4:CreateInstance(id, hero)
    return Hero40001_Skill4(id, hero)
end

--- @return void
function Hero40001_Skill4:Init()
    self.hpLimit = self.data.hpLimit
    self.triggerLimit = self.data.triggerLimit
    self.triggerChance = self.data.triggerChance

    self.effectTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.effectTargetPosition,
            TargetTeamType.ENEMY, self.data.effectTargetNumber)

    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration

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
function Hero40001_Skill4:OnHpChange(eventData)
    if self.myHero:IsDead() == false then
        if eventData.target == self.myHero and self.triggerNumber < self.triggerLimit and self.myHero.hp:GetStatPercent() <= self.hpLimit then
            self.triggerNumber = self.triggerNumber + 1
            if self.myHero.randomHelper:RandomRate(self.triggerChance) then
                self:TriggerSkill()
            end
        end
    end
end

--- @return void
function Hero40001_Skill4:TriggerSkill()
    local enemyTargetList = self.effectTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= enemyTargetList:Count() do
        local target = enemyTargetList:Get(i)
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.effectType, self.effectDuration)
        target.effectController:AddEffect(ccEffect)
        i = i + 1
    end

    local allyTargetList = self.statBuffTargetSelector:SelectTarget(self.myHero.battle)
    i = 1
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

return Hero40001_Skill4