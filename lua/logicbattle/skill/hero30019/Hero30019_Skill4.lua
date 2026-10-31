--- @class Hero30019_Skill4 Elne
Hero30019_Skill4 = Class(Hero30019_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero30019_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil
    --- @type number
    self.healthTrigger = nil
    --- @type number
    self.effectType = nil
    --- @type number
    self.effectDuration = nil
    --- @type number
    self.effectAmount = nil

    --- @type boolean
    self.isActive = false
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero30019_Skill4:CreateInstance(id, hero)
    return Hero30019_Skill4(id, hero)
end

--- @return void
function Hero30019_Skill4:Init()
    self.healthTrigger = self.data.healthTrigger
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration
    self.effectAmount = self.data.effectAmount

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

-------------------------------------------BATTLE------------------------------
--- @return void
--- @param eventData table
function Hero30019_Skill4:OnHpChange(eventData)
    if eventData.target == self.myHero then
        if self.myHero:IsDead() == false then
            if self.isActive == false and self.myHero.hp:GetStatPercent() < self.healthTrigger then
                self.isActive = true
                self:InflictDot()
            end
        end
    end
end

--- @return void
function Hero30019_Skill4:InflictDot()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, target, self.effectType, self.effectDuration, self.effectAmount)
        target.effectController:AddEffect(dotEffect)
        i = i + 1
    end
end

return Hero30019_Skill4
