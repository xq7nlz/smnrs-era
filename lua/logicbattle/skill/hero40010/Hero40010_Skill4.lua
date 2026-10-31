--- @class Hero40010_Skill4 Yome
Hero40010_Skill4 = Class(Hero40010_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40010_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    ---@type EffectType
    self.effectDotType = nil
    ---@type number
    self.effectDotAmount = nil
    ---@type number
    self.effectDotDuration = nil

    --- @type boolean
    self.isTrigger = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40010_Skill4:CreateInstance(id, hero)
    return Hero40010_Skill4(id, hero)
end

--- @return void
function Hero40010_Skill4:Init()
    self.effectDotType = self.data.effectDotType
    self.effectDotAmount = self.data.effectDotAmount
    self.effectDotDuration = self.data.effectDotDuration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero40010_Skill4:OnHeroDead(eventData)
    if eventData.target == self.myHero and self.isTrigger == false then
        self.isTrigger = true
        self:InflictEffect()
    end
end

--- @return void
function Hero40010_Skill4:InflictEffect()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, target, self.effectDotType, self.effectDotDuration, self.effectDotAmount)
        target.effectController:AddEffect(dotEffect)
        i = i + 1
    end
end

return Hero40010_Skill4