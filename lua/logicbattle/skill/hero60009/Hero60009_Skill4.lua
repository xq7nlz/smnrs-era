--- @class Hero60009_Skill4 Khann
Hero60009_Skill4 = Class(Hero60009_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero60009_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type DamageSkillHelper
    self.subActiveSkillHelper = nil

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number
    self.damageMultiplier = nil

    --- @type Dictionary
    self.isTriggerByHero = Dictionary()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero60009_Skill4:CreateInstance(id, hero)
    return Hero60009_Skill4(id, hero)
end

--- @return void
function Hero60009_Skill4:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageMultiplier = self.data.damageMultiplier

    self.subActiveSkillHelper = SubActiveSkillHelper(self)

    local listener = EventListener(self.myHero, self, self.OnHeroDead)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_DEAD, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param eventData table
function Hero60009_Skill4:OnHeroDead(eventData)
    local enemyHero = eventData.target
    if self:CanTrigger(enemyHero) == true then
        self.isTriggerByHero:Add(enemyHero, true)

        self.subActiveSkillHelper:SetInfo(self.damageMultiplier)

        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            if target:IsDead() == false then
                self.subActiveSkillHelper:UseSubActiveSkillOnTarget(target)
            end
            i = i + 1
        end
    end
end

--- @return void
--- @param target BaseHero
function Hero60009_Skill4:CanTrigger(target)
    if self.myHero:IsDead() == false then
        if target:IsAlly(self.myHero) == false
                and target.effectController:IsContainEffectType(EffectType.DISEASE_MARK) then

            local isTrigger = self.isTriggerByHero:Get(target)
            if isTrigger == nil or isTrigger == false then
                return true
            end
        end
    end
    return false
end

return Hero60009_Skill4
