--- @class ArmorBreakStat : BaseHeroStat
ArmorBreakStat = Class(ArmorBreakStat, BaseHeroStat)

--- @return void
--- @param hero BaseHero
function ArmorBreakStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.ARMOR_BREAK, StatValueType.PERCENT)

    self._maxValue = 1
end

--- @return void
function ArmorBreakStat:Calculate()
    BaseHeroStat.Calculate(self)

    self._maxValue = BattleConstants.MAX_ARMOR_BREAK_STAT
    self:_LimitStat()
end

--- @return string
function ArmorBreakStat:ToString()
    return string.format("armorBreak = %s\n", self:GetValue())
end