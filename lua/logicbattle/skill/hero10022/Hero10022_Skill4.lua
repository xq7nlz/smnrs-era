--- @class Hero10022_Skill4 AquaMage
Hero10022_Skill4 = Class(Hero10022_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero10022_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healthTrigger = nil
    --- @type number
    self.statBuffDuration = nil
    --- @type number
    self.statBuffType = nil
    --- @type number
    self.statBuffCalculationType = nil
    --- @type number
    self.statBuffAmount = nil

    --- @type boolean
    self.isActive = false
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero10022_Skill4:CreateInstance(id, hero)
    return Hero10022_Skill4(id, hero)
end

--- @return void
function Hero10022_Skill4:Init()
    self.healthTrigger = self.data.healthTrigger
    self.statBuffDuration = self.data.statBuffDuration
    self.statBuffType = self.data.statBuffType
    self.statBuffCalculationType = self.data.statBuffCalculationType
    self.statBuffAmount = self.data.statBuffAmount

    local listener = EventListener(self.myHero, self, self.OnHpChange)
    self.myHero.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

-------------------------------------------BATTLE------------------------------
--- @return void
--- @param eventData table
function Hero10022_Skill4:OnHpChange(eventData)
    if eventData.target == self.myHero then
        if self.myHero:IsDead() == false then
            if self.isActive == false and self.myHero.hp:GetStatPercent() < self.healthTrigger then
                self:BuffStat()
                self.isActive = true
            end
        end
    end
end

--- @return void
function Hero10022_Skill4:BuffStat()
    local effectBuffPassive = StatChangerEffect(self.myHero, self.myHero, true)
    effectBuffPassive:SetDuration(self.statBuffDuration)
    local effectBuff = StatChanger(true)
    effectBuff:SetInfo(self.statBuffType, self.statBuffCalculationType, self.statBuffAmount)

    effectBuffPassive:AddStatChanger(effectBuff)
    self.myHero.effectController:AddEffect(effectBuffPassive)
end

return Hero10022_Skill4
