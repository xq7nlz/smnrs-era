--- @class CCResistanceStat : BaseHeroStat
CCResistanceStat = Class(CCResistanceStat, BaseHeroStat)

--- @return void
--- @param hero BaseHero
function CCResistanceStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.CC_RESISTANCE, StatValueType.PERCENT)

    self._maxValue = 1
end

--- @return void
function CCResistanceStat:Calculate()
    BaseHeroStat.Calculate(self)

    self._maxValue = BattleConstants.MAX_CC_RESISTANCE_STAT
    self:_LimitStat()
end

--- @return string
function CCResistanceStat:ToString()
    return string.format("ccResistance = %s\n", self:GetValue())
end