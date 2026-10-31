--- @class Hero40004_Skill4 Cennunos
Hero40004_Skill4 = Class(Hero40004_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero40004_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    -------------- FIRST BUFF ----------------
    --- @type number
    self.firstHealthTriggerBuff = nil

    -------------- SECOND BUFF ----------------
    --- @type number
    self.secondHealthTriggerBuff = nil

    -----------------------------------------------------------
    --- @type boolean
    self.isActiveFirstBuff = false

    --- @type boolean
    self.isActiveSecondBuff = false

    --- @type StatChangerEffect
    self.firstEffectBuffPassive = nil

    --- @type StatChangerEffect
    self.secondEffectBuffPassive = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40004_Skill4:CreateInstance(id, hero)
    return Hero40004_Skill4(id, hero)
end

--- @return void
function Hero40004_Skill4:Init()
    self:ParseCsvThenInitFirstBuff()
    self:ParseCsvThenInitSecondBuff()

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)

    listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_HEAL, listener)

    listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_REVIVE, listener)

    self:CalculatorBuff()
end

--- @return void
function Hero40004_Skill4:ParseCsvThenInitFirstBuff()
    ----------------------------- Buff --------------------------------------
    self.firstHealthTriggerBuff = self.data.firstHealthTriggerBuff

    local effectBuffFirst = StatChanger(true)
    effectBuffFirst:SetInfo(self.data.statFirstBuffType, StatChangerCalculationType.PERCENT_ADD, self.data.statFirstBuffAmount)

    local effectBuffSecond = StatChanger(true)
    effectBuffSecond:SetInfo(self.data.statSecondBuffType, StatChangerCalculationType.PERCENT_ADD, self.data.statSecondBuffAmount)

    self.firstEffectBuffPassive = StatChangerEffect(self.myHero, self.myHero, true)
    self.firstEffectBuffPassive:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)
    self.firstEffectBuffPassive:AddStatChanger(effectBuffFirst)
    self.firstEffectBuffPassive:AddStatChanger(effectBuffSecond)
end

--- @return void
function Hero40004_Skill4:ParseCsvThenInitSecondBuff()
    ----------------------------- Debuff --------------------------------------
    self.secondHealthTriggerBuff = self.data.secondHealthTriggerBuff

    local effectBuffFirst = StatChanger(true)
    effectBuffFirst:SetInfo(self.data.secondTriggerFirstStatBuffType, StatChangerCalculationType.PERCENT_ADD, self.data.secondTriggerFirstStatBuffAmount)

    local effectBuffSecond = StatChanger(true)
    effectBuffSecond:SetInfo(self.data.secondTriggerSecondStatBuffType, StatChangerCalculationType.PERCENT_ADD, self.data.secondTriggerSecondStatBuffAmount)

    self.secondEffectBuffPassive = StatChangerEffect(self.myHero, self.myHero, true)
    self.secondEffectBuffPassive:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)
    self.secondEffectBuffPassive:AddStatChanger(effectBuffFirst)
    self.secondEffectBuffPassive:AddStatChanger(effectBuffSecond)
end

-------------------------------------------BATTLE------------------------------
--- @return number
--- @param eventData table
function Hero40004_Skill4:OnHpChange(eventData)
    local target = eventData.target
    if target == self.myHero then
        self:CalculatorBuff()
    end
end

function Hero40004_Skill4:CalculatorBuff()
    if self.myHero:IsDead() == false then
        if self.myHero.hp:GetStatPercent() > self.firstHealthTriggerBuff then
            if self.isActiveFirstBuff == false then
                self:BuffFirstPassive()
                self.isActiveFirstBuff = true
            end
        else
            if self.isActiveFirstBuff then
                self:RemoveBuffFirstPassive()
                self.isActiveFirstBuff = false
            end
        end

        if self.myHero.hp:GetStatPercent() < self.secondHealthTriggerBuff then
            if self.isActiveSecondBuff == false then
                self:BuffSecondPassive()
                self.isActiveSecondBuff = true
            end
        else
            if self.isActiveSecondBuff then
                self:RemoveBuffSecondPassive()
                self.isActiveSecondBuff = false
            end
        end
    else
        self:RemoveBuffFirstPassive()
        self:RemoveBuffSecondPassive()
        self.isActiveFirstBuff = false
        self.isActiveSecondBuff = false
    end
end

------------------------------------- TRIGGER ------------------------------------
--- @return void
function Hero40004_Skill4:BuffFirstPassive()
    self.myHero.effectController:AddEffect(self.firstEffectBuffPassive)
end

--- @return void
function Hero40004_Skill4:BuffSecondPassive()
    self.myHero.effectController:AddEffect(self.secondEffectBuffPassive)
end

---------------------------------- RETURN --------------------------------------------
--- @return void
function Hero40004_Skill4:RemoveBuffFirstPassive()
    self.myHero.effectController:ForceRemove(self.firstEffectBuffPassive)
end

--- @return void
function Hero40004_Skill4:RemoveBuffSecondPassive()
    self.myHero.effectController:ForceRemove(self.secondEffectBuffPassive)
end

return Hero40004_Skill4
