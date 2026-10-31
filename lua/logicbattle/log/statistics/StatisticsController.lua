--- @class StatisticsController
StatisticsController = Class(StatisticsController)

--- @return void
--- @param battle Battle
function StatisticsController:Ctor(battle)
    --- @type Battle
    self.battle = battle

    --- @type Dictionary<BaseHero, HeroStatistics>
    self.heroStatisticsDict = Dictionary()
end

--- @return void
--- @param hero BaseHero
function StatisticsController:AddHero(hero)
    ---@type HeroStatistics
    local statistics = HeroStatistics(hero)
    self.heroStatisticsDict:Add(hero, statistics)
end

--- @return void
--- @param initiator BaseHero
--- @param damage number
--- @param damageReason TakeDamageReason
function StatisticsController:AddDamageDeal(initiator, damage, damageReason)
    ---@type HeroStatistics
    local initiatorStatistics = self.heroStatisticsDict:Get(initiator)
    initiatorStatistics:AddDamageDeal(damage, damageReason)
end

--- @return void
--- @param target BaseHero
--- @param damage number
--- @param damageReason TakeDamageReason
function StatisticsController:AddDamageTakenThroughFormula(target, damage, damageReason)
    ---@type HeroStatistics
    local targetStatistics = self.heroStatisticsDict:Get(target)
    targetStatistics:AddDamageTaken(damage, damageReason)
end

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param healAmount number
--- @param healReason HealReason
function StatisticsController:AddHpHeal(initiator, target, healAmount, healReason)
    ---@type HeroStatistics
    local initiatorStatistics = self.heroStatisticsDict:Get(initiator)
    initiatorStatistics:AddHpHeal(healAmount, healReason)
    ---@type HeroStatistics
    local targetStatistics = self.heroStatisticsDict:Get(target)
    targetStatistics:AddHpHealTaken(healAmount, healReason)
end

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function StatisticsController:AddHeroDead(initiator, target)
    ---@type HeroStatistics
    local initiatorStatistics = self.heroStatisticsDict:Get(initiator)
    initiatorStatistics:AddKill()
    ---@type HeroStatistics
    local targetStatistics = self.heroStatisticsDict:Get(target)
    targetStatistics:AddDead()
end

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function StatisticsController:AddHeroRevived(initiator, target)
    ---@type HeroStatistics
    local initiatorStatistics = self.heroStatisticsDict:Get(initiator)
    initiatorStatistics:AddRevive()
    ---@type HeroStatistics
    local targetStatistics = self.heroStatisticsDict:Get(target)
    targetStatistics:AddBeRevived()
end

--- @return void
--- @param effect BaseEffect
function StatisticsController:OnEffectAdd(effect)
    if effect.type ~= EffectType.STAT_CHANGER then
        ---@type BaseHero
        local initiator = effect.initiator
        ---@type HeroStatistics
        local initiatorStatistics = self.heroStatisticsDict:Get(initiator)
        initiatorStatistics:OnEffectAdd(effect)
    end
end

--- @return void
--- @param initiator BaseHero
--- @param statAffectedType StatType
--- @param amount number
--- @param isBuff boolean
function StatisticsController:OnStatChangerAdd(initiator, statAffectedType, amount, isBuff)
    ---@type HeroStatistics
    local initiatorStatistics = self.heroStatisticsDict:Get(initiator)
    initiatorStatistics:OnStatChangerAdd(statAffectedType, amount, isBuff)
end

--- @return string
function StatisticsController:ToString()
    local str = ""
    --- @param v HeroStatistics
    for _, v in pairs(self.heroStatisticsDict:GetItems()) do
        str = str .. "\n" .. v:ToString()
    end
    return str
end