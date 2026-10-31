--- @class ReduceDamageReductionStat : BaseHeroStat
ReduceDamageReductionStat = Class(ReduceDamageReductionStat, BaseHeroStat)

--- @return void
--- @param hero BaseHero
function ReduceDamageReductionStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.REDUCE_DAMAGE_REDUCTION, StatValueType.PERCENT)

    self._maxValue = 1
end

----- @return void
function ReduceDamageReductionStat:Calculate()
    BaseHeroStat.Calculate(self)

    self._maxValue = BattleConstants.MAX_REDUCE_DAMAGE_REDUCTION_STAT
    self:_LimitStat()
end

--- @return string
function ReduceDamageReductionStat:ToString()
    return string.format("reduceDamageReduction = %s\n", self:GetValue())
end