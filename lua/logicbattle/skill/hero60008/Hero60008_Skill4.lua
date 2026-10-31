--- @class Hero60008_Skill4 Renaks
Hero60008_Skill4 = Class(Hero60008_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero60008_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)
    --- @type number
    self.healthTrigger = nil

    --- @type EffectType
    self.statBuffType = nil
    --- @type number
    self.statBuffAmount = 0
    --- @type number
    self.statBuffDuration = 0

    --- @type number
    self.triggerChance = 0

    --- @type number
    self.healAmount = 0

    --- @type boolean
    self.isActive = false

    --- @type StatChangerEffect
    self.effectBuffPassive = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero60008_Skill4:CreateInstance(id, hero)
    return Hero60008_Skill4(id, hero)
end

--- @return void
function Hero60008_Skill4:Init()
    self.healthTrigger = self.data.healthTrigger
    self.statBuffDuration = self.data.statBuffDuration
    self.statBuffType = self.data.statBuffType
    self.statBuffAmount = self.data.statBuffAmount

    self.healAmount = self.data.healAmount
    self.triggerChance = self.data.triggerChance

    local listener = EventListener(self.myHero, self, self.TakeDamage)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

-------------------------------------------BATTLE------------------------------
--- @return number
--- @param eventData table
function Hero60008_Skill4:TakeDamage(eventData)
    local target = eventData.target
    if target == self.myHero and self.myHero:IsDead() == false then
        if self.isActive == false and self.myHero.hp:GetStatPercent() < self.healthTrigger then
            if self.myHero.randomHelper:RandomRate(self.triggerChance) then
                self:BuffHeal()
                self:BuffPassive()
            end
            self.isActive = true
        end
    end
end

--- @return void
function Hero60008_Skill4:BuffHeal()
    local healAmount = self.healAmount * self.myHero.hp:GetMax()
    HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.RENAK_HEAL_SKILL)
end

--- @return void
function Hero60008_Skill4:BuffPassive()
    local effectBuffPassive = StatChangerEffect(self.myHero, self.myHero, true)
    effectBuffPassive:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
    effectBuffPassive:SetDuration(self.statBuffDuration)

    local effectBuff = StatChanger(true)
    effectBuff:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

    effectBuffPassive:AddStatChanger(effectBuff)
    self.myHero.effectController:AddEffect(effectBuffPassive)
end

return Hero60008_Skill4
