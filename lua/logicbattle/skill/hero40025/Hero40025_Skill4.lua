--- @class Hero40025_Skill4 Arason
Hero40025_Skill4 = Class(Hero40025_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40025_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.triggerLimit = nil
    --- @type number
    self.triggerNumber = 0

    --- @type BaseTargetSelector
    self.healTargetSelector = nil
    --- @type number
    self.healAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40025_Skill4:CreateInstance(id, hero)
    return Hero40025_Skill4(id, hero)
end

--- @return void
function Hero40025_Skill4:Init()
    self.triggerLimit = self.data.triggerLimit
    self.healAmount = self.data.healAmount

    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

--- @return void
--- @param eventData table
function Hero40025_Skill4:OnHeroDead(eventData)
    if eventData.target == self.myHero and self.triggerNumber < self.triggerLimit then
        self.triggerNumber = self.triggerNumber + 1

        local healAmount = self.healAmount * self.myHero.attack:GetValue()

        local targetList = self.healTargetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
            i = i + 1
        end
    end
end

return Hero40025_Skill4