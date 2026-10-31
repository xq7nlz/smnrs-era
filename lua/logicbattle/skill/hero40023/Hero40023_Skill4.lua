--- @class Hero40023_Skill4 HoundMaster
Hero40023_Skill4 = Class(Hero40023_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero40023_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healthTrigger = nil

    --- @type StatChangerEffect
    self.effectBuffPassive = nil

    --- @type boolean
    self.isActive = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40023_Skill4:CreateInstance(id, hero)
    return Hero40023_Skill4(id, hero)
end

--- @return void
function Hero40023_Skill4:Init()
    self.healthTrigger = self.data.healthTrigger

    self.effectBuffPassive = StatChangerEffect(self.myHero, self.myHero, true)
    self.effectBuffPassive:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)

    --- @type StatType
    local effectBuffFirst = StatChanger(true)
    effectBuffFirst:SetInfo(self.data.statFirstType, self.data.statFirstCalculationType, self.data.statFirstBuffAmount)

    --- @type StatType
    local effectBuffSecond = StatChanger(true)
    effectBuffSecond:SetInfo(self.data.statSecondType, self.data.statSecondCalculationType, self.data.statSecondBuffAmount)

    self.effectBuffPassive:AddStatChanger(effectBuffFirst)
    self.effectBuffPassive:AddStatChanger(effectBuffSecond)

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_HEAL, listener)
end

-------------------------------------------BATTLE------------------------------
--- @return void
--- @param eventData table
function Hero40023_Skill4:OnHpChange(eventData)
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
function Hero40023_Skill4:BuffPassive()
    self.myHero.effectController:AddEffect(self.effectBuffPassive)
end

--- @return void
function Hero40023_Skill4:RemoveBuffPassive()
    self.myHero.effectController:ForceRemove(self.effectBuffPassive)
end

return Hero40023_Skill4