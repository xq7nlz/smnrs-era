--- @class Hero10006_Skill4 Aqualord
Hero10006_Skill4 = Class(Hero10006_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10006_Skill4:Ctor(id, hero)
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
    --- @type number
    self.effectAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10006_Skill4:CreateInstance(id, hero)
    return Hero10006_Skill4(id, hero)
end

--- @return void
function Hero10006_Skill4:Init()
    self.hpLimit = self.data.hpLimit
    self.triggerLimit = self.data.triggerLimit
    self.triggerChance = self.data.triggerChance

    self.effectTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.effectTargetPosition,
            TargetTeamType.ALLY, self.data.effectTargetNumber)

    self.effectType = self.data.effectType

    self.healSkillHelper = HealSkillHelper(self)
    self.healSkillHelper:SetHealData(self.data.effectAmount, self.data.effectDuration)

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero10006_Skill4:OnHpChange(eventData)
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
function Hero10006_Skill4:TriggerSkill()
    local targetList = self.effectTargetSelector:SelectTarget(self.myHero.battle)
    self.healSkillHelper:UseHealSkill(targetList)
end

return Hero10006_Skill4