--- @class DamageReductionStat : BaseHeroStat
DamageReductionStat = Class(DamageReductionStat, BaseHeroStat)

--- @return void
--- @param hero BaseHero
function DamageReductionStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.DAMAGE_REDUCTION, StatValueType.PERCENT)

    self._maxValue = 1
end

----- @return void
function DamageReductionStat:Calculate()
    BaseHeroStat.Calculate(self)

    self._maxValue = BattleConstants.MAX_DAMAGE_REDUCTION_STAT
    self:_LimitStat()
end

--- @return string
function DamageReductionStat:ToString()
    return string.format("damageReduction = %s\n", self:GetValue())
end