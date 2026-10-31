--- @class Hero20009_Skill4 Fragnil
Hero20009_Skill4 = Class(Hero20009_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero20009_Skill4:Ctor(id, hero)
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
    self.targetSelector = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20009_Skill4:CreateInstance(id, hero)
    return Hero20009_Skill4(id, hero)
end

--- @return void
function Hero20009_Skill4:Init()
    self.hpLimit = self.data.hpLimit
    self.triggerLimit = self.data.triggerLimit
    self.triggerChance = self.data.triggerChance

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero20009_Skill4:OnHpChange(eventData)
    if self.myHero:IsDead() == false then
        if eventData.target == self.myHero then
            if self.triggerNumber < self.triggerLimit and self.myHero.hp:GetStatPercent() <= self.hpLimit then
                self.triggerNumber = self.triggerNumber + 1
                if self.myHero.randomHelper:RandomRate(self.triggerChance) then
                    self:TriggerSkill()
                end
            end
        end
    end
end

--- @return void
function Hero20009_Skill4:TriggerSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        target.effectController:DispelBuff()
        i = i + 1
    end
end

return Hero20009_Skill4
