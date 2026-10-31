--- @class Hero50013_Skill4
Hero50013_Skill4 = Class(Hero50013_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50013_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    self.isActive = false

    --- @type number
    self.healthTrigger = 0
    --------------------- EFFECT 1 ------------------------

    --- @type BaseTargetSelector
    self.healTargetSelector = nil

    --- @type number
    self.healAmount = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50013_Skill4:CreateInstance(id, hero)
    return Hero50013_Skill4(id, hero)
end

---- @return void
function Hero50013_Skill4:Init()
    self.healAmount = self.data.healAmount
    self.healthTrigger = self.data.healthTrigger

    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPositionHeal,
            TargetTeamType.ALLY, self.data.targetNumberHeal)

    local listener = EventListener(self.myHero, self, self.TakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

-------------------------------------------BATTLE------------------------------
--- @return number
--- @param eventData table
function Hero50013_Skill4:TakeDamage(eventData)
    local target = eventData.target
    if target == self.myHero and self.isActive == false and self.myHero:IsDead() == false and self.myHero.hp:GetStatPercent() < self.healthTrigger then
        self:BuffHeal()
        self.isActive = true
    end
end

--- @return void
function Hero50013_Skill4:BuffHeal()
    local targetList = self.healTargetSelector:SelectTarget(self.myHero.battle)

    local healAmount = self.healAmount * self.myHero.attack:GetValue()
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
        i = i + 1
    end
end

return Hero50013_Skill4