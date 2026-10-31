--- @class HeroStatistics
HeroStatistics = Class(HeroStatistics)

--- @return void
--- @param hero BaseHero
function HeroStatistics:Ctor(hero)
    --- @type BaseHero
    self.myHero = hero

    ---------------------------------------- Damage ----------------------------------------
    --- @type number
    self.damageDeal = 0

    --- @type number
    self.damageTaken = 0

    --- @type Dictionary <TakeDamageReason, number>
    self.damageDealBySources = Dictionary()

    --- @type Dictionary <TakeDamageReason, number>
    self.damageTakenBySources = Dictionary()

    --- key: NumberRound * 1000 + NumberTurn, value: total damage dealt
    self.damageDealHistory = Dictionary()

    --- @type Dictionary
    --- key: NumberRound * 1000 + NumberTurn, value: total damage taken
    self.damageTakenHistory = Dictionary()

    ---------------------------------------- Hp heal ----------------------------------------
    --- @type number
    self.hpHeal = 0

    --- @type number
    self.hpHealTaken = 0

    --- @type Dictionary
    --- key: HealReason, value: hp heal
    self.hpHealBySources = Dictionary()

    --- @type Dictionary
    --- key: HealReason, value: hp heal
    self.hpHealTakenBySources = Dictionary()

    --- @type Dictionary
    --- key: NumberRound * 1000 + NumberTurn, value: total hp heal
    self.hpHealHistory = Dictionary()

    --- @type Dictionary
    --- key: NumberRound * 1000 + NumberTurn, value: total hp heal taken
    self.hpHealTakenHistory = Dictionary()

    ---------------------------------------- Dead/Revive ----------------------------------------
    --- @type number
    self.numberKill = 0

    --- @type number
    self.numberDead = 0

    --- @type number
    self.numberRevive = 0

    --- @type number
    self.numberBeRevived = 0

    ---------------------------------------- Effect ----------------------------------------
    --- @type Dictionary <EffectType, number>
    self.effectCreatedHistory = Dictionary()

    --- @type Dictionary <EffectType, number>
    self.statChangerBuffCreatedHistory = Dictionary()

    --- @type Dictionary <StatType, number>
    self.statChangerDebuffCreatedHistory = Dictionary()
end

---------------------------------------- Damage ----------------------------------------
--- @return void
--- @param damage number
--- @param damageReason TakeDamageReason
function HeroStatistics:AddDamageDeal(damage, damageReason)
    self.damageDeal = self.damageDeal + damage

    self:_AddOrCreate(self.damageDealBySources, damageReason, damage)
    self:_AddOrCreate(self.damageDealHistory, self:_BuildTurnIdAsKey(), damage)
end

--- @return void
--- @param damage number
--- @param damageReason TakeDamageReason
function HeroStatistics:AddDamageTaken(damage, damageReason)
    self.damageTaken = self.damageTaken + damage

    self:_AddOrCreate(self.damageTakenBySources, damageReason, damage)
    self:_AddOrCreate(self.damageTakenHistory, self:_BuildTurnIdAsKey(), damage)
end

---------------------------------------- Hp heal ----------------------------------------
--- @return void
--- @param hpHeal number
--- @param healReason HealReason
function HeroStatistics:AddHpHeal(hpHeal, healReason)
    self.hpHeal = self.hpHeal + hpHeal

    self:_AddOrCreate(self.hpHealBySources, healReason, hpHeal)
    self:_AddOrCreate(self.hpHealHistory, self:_BuildTurnIdAsKey(), hpHeal)
end

--- @return void
--- @param hpHeal number
--- @param healReason HealReason
function HeroStatistics:AddHpHealTaken(hpHeal, healReason)
    self.hpHealTaken = self.hpHealTaken + hpHeal

    self:_AddOrCreate(self.hpHealTakenBySources, healReason, hpHeal)
    self:_AddOrCreate(self.hpHealTakenHistory, self:_BuildTurnIdAsKey(), hpHeal)
end

---------------------------------------- Dead/Revive ----------------------------------------
--- @return void
function HeroStatistics:AddKill()
    self.numberKill = self.numberKill + 1
end

--- @return void
function HeroStatistics:AddDead()
    self.numberDead = self.numberDead + 1
end

--- @return void
function HeroStatistics:AddRevive()
    self.numberRevive = self.numberRevive + 1
end

--- @return void
function HeroStatistics:AddBeRevived()
    self.numberBeRevived = self.numberBeRevived + 1
end

---------------------------------------- Effect ----------------------------------------
--- @return void
--- @param effect BaseEffect
function HeroStatistics:OnEffectAdd(effect)
    self:_AddOrCreate(self.effectCreatedHistory, effect.type, effect.duration)
end

--- @return void
--- @param statAffectedType StatType
--- @param amount number
--- @param isBuff boolean
function HeroStatistics:OnStatChangerAdd(statAffectedType, amount, isBuff)
    if isBuff == true then
        self:_AddOrCreate(self.statChangerBuffCreatedHistory, statAffectedType, amount)
    else
        self:_AddOrCreate(self.statChangerDebuffCreatedHistory, statAffectedType, amount)
    end
end

---------------------------------------- Helpers ----------------------------------------
--- @return void
--- @param dict Dictionary
--- @param key number
--- @param value number
function HeroStatistics:_AddOrCreate(dict, key, value)
    local currentValue = dict:Get(key)
    if currentValue == nil then
        dict:Add(key, value)
    else
        dict:Add(key, value + currentValue)
    end
end

--- @return number
function HeroStatistics:_BuildTurnIdAsKey()
    local battle = self.myHero.battle
    return battle.numberRound * 1000 + battle.numberTurn
end

--- @return HeroStatistics
function HeroStatistics:GetData()
    local data = {}
    data.damageDeal = self.damageDeal
    data.hpHeal = self.hpHeal
    data.damageDealHistory1 = self:GetDamageDealHistory()
    data.teamId = self.myHero.teamId

    return data
end

--- @return Dictionary<number, HeroStatistics>
function HeroStatistics:GetDamageDealHistory()
    local result = {}
    for k, v in pairs(self.damageDealHistory:GetItems()) do
        result[k] = v
    end

    return result
end

--- @return string
function HeroStatistics:ToString()
    local result = string.format("%s DamageDeal = %s, DamageTaken = %s, HpHeal = %s, HpHealTaken = %s\n",
            self.myHero:ToString(), self.damageDeal, self.damageTaken, self.hpHeal, self.hpHealTaken)

    --- Damage by sources
    if self.damageDealBySources:Count() > 0 then
        result = result .. string.format("\tDamage dealt by sources: %s\n", self.damageDealBySources:ToString())
    end
    if self.damageTakenBySources:Count() > 0 then
        result = result .. string.format("\tDamage taken by sources: %s\n", self.damageTakenBySources:ToString())
    end

    --- Hp by sources
    if self.hpHealBySources:Count() > 0 then
        result = result .. string.format("\tHp heal by sources: %s\n", self.hpHealBySources:ToString())
    end
    if self.hpHealTakenBySources:Count() > 0 then
        result = result .. string.format("\tHp heal taken by sources: %s\n", self.hpHealTakenBySources:ToString())
    end

    result = result .. string.format("\tNumberKill = %s, NumberDead = %s, NumberRevive = %s, NumberBeRevived = %s\n",
            self.numberKill, self.numberDead, self.numberRevive, self.numberBeRevived)

    --- Damage history
    if self.damageDealHistory:Count() > 0 then
        result = result .. string.format("\tDamage dealt history: %s\n", self.damageDealHistory:ToString())
    end
    if self.damageTakenHistory:Count() > 0 then
        result = result .. string.format("\tDamage taken history: %s\n", self.damageTakenHistory:ToString())
    end

    --- Hp history
    if self.hpHealHistory:Count() > 0 then
        result = result .. string.format("\tHp heal history: %s\n", self.hpHealHistory:ToString())
    end
    if self.hpHealTakenHistory:Count() > 0 then
        result = result .. string.format("\tHp heal taken history: %s\n", self.hpHealTakenHistory:ToString())
    end

    --- Effect history
    if self.effectCreatedHistory:Count() > 0 then
        result = result .. string.format("\tEffect created history: %s\n", self.effectCreatedHistory:ToString())
    end
    if self.statChangerBuffCreatedHistory:Count() > 0 then
        result = result .. string.format("\tStat changer buff created history: %s\n", self.statChangerBuffCreatedHistory:ToString())
    end
    if self.statChangerDebuffCreatedHistory:Count() > 0 then
        result = result .. string.format("\tStat changer debuff created history: %s\n", self.statChangerDebuffCreatedHistory:ToString())
    end

    return result
end