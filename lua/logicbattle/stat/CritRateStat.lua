--- @class CritRateStat : BaseHeroStat
CritRateStat = Class(CritRateStat, BaseHeroStat)

--- @return void
--- @param hero BaseHero
function CritRateStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.CRIT_RATE, StatValueType.PERCENT)

    self._maxValue = 1
end

--- @return void
function CritRateStat:Calculate()
    BaseHeroStat.Calculate(self)

    self._maxValue = BattleConstants.MAX_CRIT_RATE_STAT
    self:_LimitStat()
end

--- @return string
function CritRateStat:ToString()
    return string.format("critRate = %s\n", self:GetValue())
end