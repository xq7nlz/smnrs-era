--- @class Hero50001_Skill4 AmiableAngel
Hero50001_Skill4 = Class(Hero50001_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50001_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.hpLimit = nil

    --- @type number
    self.triggerLimit = nil
    --- @type number
    self.triggerNumber = 0

    --- @type number
    self.maxHpToHeal = nil

    --- @type BaseTargetSelector
    self.targetSelector = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50001_Skill4:CreateInstance(id, hero)
    return Hero50001_Skill4(id, hero)
end

--- @return void
function Hero50001_Skill4:Init()
    self.hpLimit = self.data.hpLimit
    self.triggerLimit = self.data.triggerLimit
    self.maxHpToHeal = self.data.maxHpToHeal

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero50001_Skill4:OnHeroDead(eventData)
    if eventData.target == self.myHero and self.triggerNumber < self.triggerLimit then
        self.triggerNumber = self.triggerNumber + 1
        self:TriggerSkill()
    end
end

--- @return void
function Hero50001_Skill4:TriggerSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    if targetList:Count() > 0 then
        local healAmount = self.maxHpToHeal * self.myHero.hp:GetMax() / targetList:Count()
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
            i = i + 1
        end
    end
end

return Hero50001_Skill4