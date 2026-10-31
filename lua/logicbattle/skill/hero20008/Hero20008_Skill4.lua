--- @class Hero20008_Skill4 Moblin
Hero20008_Skill4 = Class(Hero20008_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero20008_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    -------------- BUFF ----------------
    --- @type number
    self.healthTriggerBuff_1 = nil

    -------------- DEBUFF ----------------
    --- @type number
    self.healthTriggerBuff_2 = nil

    -----------------------------------------------------------
    --- @type boolean
    self.isActiveBuff_1 = false

    --- @type boolean
    self.isActiveBuff_2 = false

    --- @type StatChangerEffect
    self.effectBuff_1 = nil

    --- @type StatChangerEffect
    self.effectBuff_2 = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20008_Skill4:CreateInstance(id, hero)
    return Hero20008_Skill4(id, hero)
end

--- @return void
function Hero20008_Skill4:Init()
    self:InitBuff_1()
    self:InitBuff_2()
end

--- @return void
function Hero20008_Skill4:InitBuff_1()
    self.healthTriggerBuff_1 = self.data.healthTriggerBuff_1

    local effectBuffFirst = StatChanger(true)
    effectBuffFirst:SetInfo(self.data.stat_1_buff_type_1, StatChangerCalculationType.PERCENT_ADD, self.data.stat_1_buff_amount_1)

    local effectBuffSecond = StatChanger(true)
    effectBuffSecond:SetInfo(self.data.stat_2_buff_type_1, StatChangerCalculationType.PERCENT_ADD, self.data.stat_2_buff_amount_1)

    self.effectBuff_1 = StatChangerEffect(self.myHero, self.myHero, true)
    self.effectBuff_1:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)
    self.effectBuff_1:AddStatChanger(effectBuffFirst)
    self.effectBuff_1:AddStatChanger(effectBuffSecond)
end

--- @return void
function Hero20008_Skill4:InitBuff_2()
    self.healthTriggerBuff_2 = self.data.healthTriggerBuff_2

    local statBuff_1 = StatChanger(true)
    statBuff_1:SetInfo(self.data.stat_1_buff_type_2, StatChangerCalculationType.PERCENT_ADD, self.data.stat_1_buff_amount_2)

    local statBuff_2 = StatChanger(true)
    statBuff_2:SetInfo(self.data.stat_2_buff_type_2, StatChangerCalculationType.PERCENT_ADD, self.data.stat_2_buff_amount_2)

    self.effectBuff_2 = StatChangerEffect(self.myHero, self.myHero, true)
    self.effectBuff_2:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)
    self.effectBuff_2:AddStatChanger(statBuff_1)
    self.effectBuff_2:AddStatChanger(statBuff_2)

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_HEAL, listener)
end

------------------------------------------- BATTLE ------------------------------
--- @return void
--- @param eventData table
function Hero20008_Skill4:OnHpChange(eventData)
    if eventData.target == self.myHero then
        if self.myHero:IsDead() == false then
            if self.myHero.hp:GetStatPercent() < self.healthTriggerBuff_1 and self.myHero.hp:GetStatPercent() > self.healthTriggerBuff_2 then
                if self.isActiveBuff_1 == false then
                    self:BuffPassive_1()
                    self.isActiveBuff_1 = true
                end
            else
                if self.isActiveBuff_1 then
                    self:RemoveBuffPassive_1()
                    self.isActiveBuff_1 = false
                end
            end

            if self.myHero.hp:GetStatPercent() < self.healthTriggerBuff_2 then
                if self.isActiveBuff_2 == false then
                    self:BuffPassive_2()
                    self.isActiveBuff_2 = true
                end
            else
                if self.isActiveBuff_2 then
                    self:RemoveBuffPassive_2()
                    self.isActiveBuff_2 = false
                end
            end
        else
            self:RemoveBuffPassive_1()
            self:RemoveBuffPassive_2()
            self.isActiveBuff_1 = false
            self.isActiveBuff_2 = false
        end
    end
end

------------------------------------- TRIGGER ------------------------------------
--- @return void
function Hero20008_Skill4:BuffPassive_1()
    self.myHero.effectController:AddEffect(self.effectBuff_1)
end

--- @return void
function Hero20008_Skill4:BuffPassive_2()
    self.myHero.effectController:AddEffect(self.effectBuff_2)
end

---------------------------------- RETURN --------------------------------------------
--- @return void
function Hero20008_Skill4:RemoveBuffPassive_1()
    self.myHero.effectController:ForceRemove(self.effectBuff_1)
end

--- @return void
function Hero20008_Skill4:RemoveBuffPassive_2()
    self.myHero.effectController:ForceRemove(self.effectBuff_2)
end

return Hero20008_Skill4
