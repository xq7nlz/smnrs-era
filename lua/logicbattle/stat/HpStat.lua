--- @class HpStat : BaseHeroStatIntegral
HpStat = Class(HpStat, BaseHeroStatIntegral)

--- @return void
--- @param hero BaseHero
function HpStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.HP, StatValueType.RAW)

    --- @type boolean
    self.isDead = false

    --- @type boolean
    self.canRevive = true

    --- @type List<DamageItemOption>
    self.damageItemOptionList = List()

    --- @type List<BaseSkill>
    --- Talent 2000101 and 2000401
    self.damageItemPassiveList = List()
end

--- @return void
function HpStat:Calculate()
    if self.myHero.battle.battlePhase == BattlePhase.PREPARE_BATTLE then
        BaseHeroStatIntegral.Calculate(self)
        self:SetStatPercent(self.myHero.startState:GetHpPercent())
    else
        local statPercent = self:GetStatPercent()
        BaseHeroStatIntegral.Calculate(self)

        self._totalValue = math.floor(statPercent * self._maxValue)
    end
end

--- @return void
--- @param itemOption DamageItemOption
function HpStat:AddDamageItemOption(itemOption)
    self.damageItemOptionList:Add(itemOption)
end

--- @return void
--- @param itemPassive BaseSkill
function HpStat:AddDamageItemPassive(itemPassive)
    self.damageItemPassiveList:Add(itemPassive)
end
---------------------------------------- Getters ----------------------------------------
--- @return boolean
function HpStat:IsDead()
    return self.isDead
end

--- @return boolean
function HpStat:CanHeal()
    return self.myHero.effectController:CanHeal()
end

--- @return boolean
function HpStat:CanRevive()
    return self.canRevive
end

--- @return string
function HpStat:ToString()
    return string.format("hp = %s/%s\n", self:GetValue(), self._maxValue)
end

---------------------------------------- Setters ----------------------------------------
--- @return number damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function HpStat:TakeDamage(initiator, reason, damage)
    if self.isDead == false then
        damage = self:OnTakeDamage(initiator, reason, damage)
        self._totalValue = self._totalValue - damage

        self:OnAfterTakeDamage(initiator, reason, damage)

        self:_LimitStat()

        if self:IsMin() then
            self:Dead(initiator, reason)
        end

        EventUtils.TriggerEventTakeDamage(initiator, self.myHero, reason, damage)

        return damage
    end

    return 0
end

--- @return boolean, number healAmount
--- @param initiator BaseHero
--- @param reason HealReason
--- @param healAmount number
function HpStat:Heal(initiator, reason, healAmount)
    if self.isDead == false and self:CanHeal() then
        healAmount = self:OnHeal(initiator, reason, healAmount)
        self._totalValue = self._totalValue + healAmount
        self:_LimitStat()

        return true, healAmount
    end

    return false, 0
end

--- @return boolean
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- Be careful when override this method
function HpStat:Dead(initiator, reason)
    if self.isDead == false then
        if self.damageItemPassiveList:Count() > 0 then
            for i = 1, self.damageItemPassiveList:Count() do
                ---@type BaseSkill
                local passiveSkill = self.damageItemPassiveList:Get(i)
                local isResist = passiveSkill:CalculateTriggerResist(reason)
                if isResist == true then
                    return false
                end
            end
        end

        self.isDead = true

        self:SetToMin()
        self.myHero.power:SetToMin()
        self.myHero.effectController:OnDead()

        EventUtils.TriggerEventDead(initiator, self.myHero, reason)

        return true
    end

    return false
end

--- @return boolean
--- @param initiator BaseHero
function HpStat:Revive(initiator)
    if self.isDead == true and self.canRevive == true and
            self.myHero.effectController:IsContainEffectType(EffectType.CURSE_MARK) == false then
        self.isDead = false

        self:Calculate()
        self:SetToMax()
        self.myHero.power:SetToMin()
        self.myHero.effectController:OnRevive()

        EventUtils.TriggerEventRevive(initiator, self.myHero)
        return true
    end

    return false
end

--- @return void
--- @param canRevive boolean
function HpStat:SetCanRevive(canRevive)
    self.canRevive = canRevive
end

---------------------------------------- Helpers ----------------------------------------
--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
--- Be careful when override this method
function HpStat:OnTakeDamage(initiator, reason, damage)
    damage = math.floor(self.myHero.effectController.effectListener:OnTakeDamage(initiator, reason, damage))
    damage = math.floor(self.myHero.battle.bondManager:OnTakeDamage(initiator, self.myHero, reason, damage))
    damage = math.floor(self.myHero.effectController.effectListener:OnLastChance(initiator, reason, damage))

    for i = 1, self.damageItemOptionList:Count() do
        local itemOption = self.damageItemOptionList:Get(i)
        damage = MathUtils.Truncate(itemOption:CalculateDamage(initiator, damage))
    end

    for i = 1, self.damageItemPassiveList:Count() do
        local itemPassive = self.damageItemPassiveList:Get(i)
        damage = MathUtils.Truncate(itemPassive:CalculateDamage(damage, nil, reason,initiator))
    end

    if damage < 0 then
        damage = 0
    end

    return damage
end

--- @return void
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function HpStat:OnAfterTakeDamage(initiator, reason, damage)
    return
end

--- @return number
--- @param initiator BaseHero
--- @param reason HealReason
--- @param healAmount number
function HpStat:OnHeal(initiator, reason, healAmount)
    healAmount = math.floor(self.myHero.effectController.effectListener:OnHeal(initiator, reason, healAmount))

    if healAmount < 0 then
        healAmount = 0
    end
    return MathUtils.Truncate(healAmount)
end