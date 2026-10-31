--- @class Hero20002_Skill4
Hero20002_Skill4 = Class(Hero20002_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20002_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    self.isActive = false

    --- @type number
    self.healthTrigger = 0
    --------------------- EFFECT 1 ------------------------

    --- @type BaseTargetSelector
    self.healTargetSelector = nil

    --- @type number
    self.healAmount = nil

    --------------------- EFFECT 2 ------------------------

    ------ @type BaseTargetSelector
    self.effectTargetSelector = nil

    --- @type EffectType
    self.statBuffType = nil

    --- @type number
    self.statBuffAmount = nil

    --- @type number
    self.statBuffDuration = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20002_Skill4:CreateInstance(id, hero)
    return Hero20002_Skill4(id, hero)
end

---- @return void
function Hero20002_Skill4:Init()
    self.healAmount = self.data.healAmount

    self.statBuffType = self.data.statBuffType
    self.statBuffDuration = self.data.statBuffDuration
    self.statBuffAmount = self.data.statBuffAmount
    self.healthTrigger = self.data.healthTrigger

    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPositionHeal,
            TargetTeamType.ALLY, self.data.targetNumberHeal)

    self.effectTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPositionEffect,
            TargetTeamType.ALLY, self.data.targetNumberEffect)

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

----------------------------------------- Calculate -------------------------------------
--- @return void
--- @param eventData table
function Hero20002_Skill4:OnHpChange(eventData)
    if eventData.target == self.myHero then
        if self.isActive == false and self.myHero:IsDead() == false and
                self.myHero.hp:GetStatPercent() < self.healthTrigger then
            self:BuffHeal()
            self:BuffStat()
            self.isActive = true
        end
    end
end

--- @return void
function Hero20002_Skill4:BuffHeal()
    local targetList = self.healTargetSelector:SelectTarget(self.myHero.battle)

    local healAmount = self.healAmount * self.myHero.attack:GetValue()
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
        i = i + 1
    end
end

--- @return void
function Hero20002_Skill4:BuffStat()
    local targetList = self.effectTargetSelector:SelectTarget(self.myHero.battle)

    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)

        local statChangerEffect = StatChanger(true)
        statChangerEffect:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

        local effect = StatChangerEffect(self.myHero, target, true)
        effect:SetDuration(self.statBuffDuration)
        effect:AddStatChanger(statChangerEffect)

        target.effectController:AddEffect(effect)
        i = i + 1
    end
end

return Hero20002_Skill4