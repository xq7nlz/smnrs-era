--- @class Hero20014_Skill4
Hero20014_Skill4 = Class(Hero20014_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20014_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    self.isActive = false

    --- @type number
    self.healthTrigger = 0

    --- @type BaseTargetSelector
    self.powerBuffTargetSelector = nil

    --- @type number
    self.powerBuffAmount = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20014_Skill4:CreateInstance(id, hero)
    return Hero20014_Skill4(id, hero)
end

---- @return void
function Hero20014_Skill4:Init()
    self.powerBuffAmount = self.data.powerBuffAmount
    self.healthTrigger = self.data.healthTrigger

    self.powerBuffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPositionBuffPower,
            TargetTeamType.ALLY, self.data.targetNumberBuffPower)

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

----------------------------------------- Calculate -------------------------------------
--- @return void
--- @param eventData table
function Hero20014_Skill4:OnHpChange(eventData)
    if eventData.target == self.myHero then
        if self.isActive == false and self.myHero:IsDead() == false and
                self.myHero.hp:GetStatPercent() < self.healthTrigger then
            self:BuffPower()
            self.isActive = true
        end
    end
end

--- @return void
function Hero20014_Skill4:BuffPower()
    local targetList = self.powerBuffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        PowerUtils.GainPower(self.myHero, target, self.powerBuffAmount, false)
        i = i + 1
    end
end

return Hero20014_Skill4