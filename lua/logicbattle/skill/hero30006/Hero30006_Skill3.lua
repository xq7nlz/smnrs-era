--- @class Hero30006_Skill3 Thanatos
Hero30006_Skill3 = Class(Hero30006_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30006_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.hpLimit = nil

    --- @type number
    self.healAmount = nil

    --- @type number
    self.healDuration = nil

    --- @type number
    self.triggerLimit = nil

    --- @type number
    self.triggerNumber = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30006_Skill3:CreateInstance(id, hero)
    return Hero30006_Skill3(id, hero)
end

--- @return void
function Hero30006_Skill3:Init()
    self.hpLimit = self.data.hpLimit
    self.healAmount = self.data.healAmount
    self.healDuration = self.data.healDuration
    self.triggerLimit = self.data.triggerLimit

    self.myHero:BindingWithSkill_3(self)

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)

    listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_HEAL, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return boolean
function Hero30006_Skill3:CanBeTargetedByEnemy()
    if self.myHero.effectController:IsContainEffectType(EffectType.NON_TARGETED_MARK) then
        return false
    end
    return true
end

--- @return void
--- @param eventData table
function Hero30006_Skill3:OnHpChange(eventData)
    if self.myHero:IsDead() == false then
        if eventData.target == self.myHero then
            if self.myHero.hp:GetStatPercent() <= self.hpLimit then
                if self.triggerNumber < self.triggerLimit then
                    self:SwitchTargetedByEnemyState(false)
                    self.triggerNumber = self.triggerNumber + 1

                    local healAmount = self.healAmount * self.myHero.hp:GetMax()

                    HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.THANATOS_HEAL_SKILL)
                    if self.healDuration > 0 then
                        local thanatosEffect = Hero30006_HealEffect(self.myHero, self.myHero, healAmount)
                        thanatosEffect:SetDuration(self.healDuration)
                        self.myHero.effectController:AddEffect(thanatosEffect)
                    end
                end
            else
                self:SwitchTargetedByEnemyState(true)
            end
        end
    end
end

--- @return void
--- @param canBeTargetedByEnemy boolean
function Hero30006_Skill3:SwitchTargetedByEnemyState(canBeTargetedByEnemy)
    if canBeTargetedByEnemy == false then
        local nonTargetedMark = NonTargetedMark(self.myHero, self.myHero)
        nonTargetedMark:SetDuration(self.healDuration)

        self.myHero.effectController:AddEffect(nonTargetedMark)
    end
end

return Hero30006_Skill3