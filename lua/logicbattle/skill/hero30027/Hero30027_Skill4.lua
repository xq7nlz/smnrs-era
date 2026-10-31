--- @class Hero30027_Skill4 : BaseSkill
Hero30027_Skill4 = Class(Hero30027_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30027_Skill4:Ctor(id, hero)
    --- @type Hero30027_Skill4_Data
    self.data = nil
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.triggerRound = nil

    --- @type number
    self.triggerRoundLimit = nil

    --- @type boolean
    self.isTriggerNonTarget = nil

    --- @type boolean
    self.isCalculateNewStat = nil


end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30027_Skill4:CreateInstance(id, hero)
    return Hero30027_Skill4(id, hero)
end

--- @return void
function Hero30027_Skill4:Init()
    self.triggerRoundLimit = self.data.triggerRound
    self.triggerRound = 0
    self.isTriggerNonTarget = false
    self.isCalculateNewStat = false

    self.myHero:BindingWithSkill_4(self)
    self.myHero.hp:BindingWithSkill_4(self)
    self.myHero.battleListener:BindingWithSkill_4(self)

    self.myHero.effectController:BindingWithSkill_4(self)
end

--- @return void
--- @param round BattleRound
function Hero30027_Skill4:OnStartBattleRound(round)
    if self.myHero:IsDead() then
        return
    end

    if self.isTriggerNonTarget == true then
        self.triggerRound = self.triggerRound + 1
    end

    if self.isCalculateNewStat == false and self.triggerRound > self.triggerRoundLimit then
        self.isCalculateNewStat = true

        self:CalculateNewStat()
    end
end

--- @return number
function Hero30027_Skill4:GetNewAttackStatPercent()
    return self.data.newAttackPercent / 100
end

--- @return boolean
function Hero30027_Skill4:IsCalculateNewStat()
    return self.isCalculateNewStat
end

---------------------------------------- Calculate ----------------------------------------
--- @return boolean
function Hero30027_Skill4:CanBeTargeted()
    if self.myHero.effectController:IsContainEffectType(EffectType.NON_TARGETED_MARK) then
        return false
    end
    return true
end

--- @return void
function Hero30027_Skill4:CalculateNewStat()
    self.myHero.attack:UpdateStatByPercent(self.data.newAttackPercent)
    self.myHero.defense:UpdateStatByPercent(self.data.newDefensePercent)

    self.myHero.hp:SetToMax()
    self.myHero.hp:UpdateStatByPercent(self.data.newHpPercent)

    for _, heroStat in pairs(self.myHero.heroStats:GetItems()) do
        heroStat:Calculate()
    end
end

--- @return boolean, number
--- @param damage number
function Hero30027_Skill4:OnTakeDamage(damage)
    if self.isTriggerNonTarget == false then
        local currentHpValue = self.myHero.hp:GetValue()
        if currentHpValue <= damage then
            self:OnTriggerNonTarget()

            local receivedDamage = currentHpValue - self.data.triggerHp
            return true, receivedDamage
        end
    else
        if self.myHero.effectController:IsContainEffectType(EffectType.NON_TARGETED_MARK) then
            return true, 0
        end
    end

    return false, damage
end

--- @return boolean, number
--- @param healAmount number
function Hero30027_Skill4:OnHeal(healAmount)
    if self:IsTriggerNonTarget() == true then
        return true, 0
    end

    return false, healAmount
end

--- @return void
function Hero30027_Skill4:OnTriggerNonTarget()
    self.isTriggerNonTarget = true
    self.triggerRound = self.triggerRound + 1

    self.myHero.effectController:DispelBuff()
    self.myHero.effectController:DispelAllDebuff()

    local nonTargetedMark = NonTargetedMark(self.myHero, self.myHero)
    nonTargetedMark:SetDuration(self.triggerRoundLimit)

    self.myHero.effectController:AddEffect(nonTargetedMark)
end

--- @return boolean
function Hero30027_Skill4:IsTriggerNonTarget()
    if self.isTriggerNonTarget == false then
        return false
    end

    return self.myHero.effectController:IsContainEffectType(EffectType.NON_TARGETED_MARK)
end

return Hero30027_Skill4