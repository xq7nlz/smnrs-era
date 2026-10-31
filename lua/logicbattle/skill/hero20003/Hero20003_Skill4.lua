--- @class Hero20003_Skill4 Eitri
Hero20003_Skill4 = Class(Hero20003_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero20003_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healthTrigger = nil

    --- @type boolean
    self.isActive = false

    --- @type StatChangerEffect
    self.effectBuffPassive = nil

    --- @type StatChangerEffect
    self.effectDeBuffPassive = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20003_Skill4:CreateInstance(id, hero)
    return Hero20003_Skill4(id, hero)
end

--- @return void
function Hero20003_Skill4:Init()
    self.healthTrigger = self.data.healthTrigger

    self.effectBuffPassive = StatChangerEffect(self.myHero, self.myHero, true)
    self.effectBuffPassive:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)

    self.effectDeBuffPassive = StatChangerEffect(self.myHero, self.myHero, false)
    self.effectDeBuffPassive:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)

    --- @type StatType
    local effectBuffFirst = StatChanger(true)
    effectBuffFirst:SetInfo(self.data.statFirstType, StatChangerCalculationType.PERCENT_ADD, self.data.statFirstBuffAmount)

    --- @type StatType
    local effectBuffSecond = StatChanger(true)
    effectBuffSecond:SetInfo(self.data.statSecondType, StatChangerCalculationType.PERCENT_ADD, self.data.statSecondBuffAmount)

    --- @type StatType
    local effectDebuff = StatChanger(false)
    effectDebuff:SetInfo(self.data.statDebuffType, StatChangerCalculationType.PERCENT_ADD, self.data.statDebuffAmount)

    self.effectBuffPassive:AddStatChanger(effectBuffFirst)
    self.effectBuffPassive:AddStatChanger(effectBuffSecond)
    self.effectDeBuffPassive:AddStatChanger(effectDebuff)

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_HEAL, listener)
end

-------------------------------------------BATTLE------------------------------
--- @return void
--- @param eventData table
function Hero20003_Skill4:OnHpChange(eventData)
    if eventData.target == self.myHero then
        if self.myHero:IsDead() == false then
            if self.myHero.hp:GetStatPercent() < self.healthTrigger then
                if self.isActive == false then
                    self:BuffPassive()
                    self.isActive = true
                end
            else
                if self.isActive then
                    self:RemoveBuffPassive()
                    self.isActive = false
                end
            end
        else
            self:RemoveBuffPassive()
            self.isActive = false
        end
    end
end

--- @return void
function Hero20003_Skill4:BuffPassive()
    self.myHero.effectController:AddEffect(self.effectBuffPassive)
    self.myHero.effectController:AddEffect(self.effectDeBuffPassive)
end

--- @return void
function Hero20003_Skill4:RemoveBuffPassive()
    self.myHero.effectController:ForceRemove(self.effectBuffPassive)
    self.myHero.effectController:ForceRemove(self.effectDeBuffPassive)
end

return Hero20003_Skill4
