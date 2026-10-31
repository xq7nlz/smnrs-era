--- @class PureDamageStat : BaseHeroStat
PureDamageStat = Class(PureDamageStat, BaseHeroStat)

--- @return void
--- @param hero BaseHero
function PureDamageStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.PURE_DAMAGE, StatValueType.PERCENT)
end

---------------------------------------- Getters ----------------------------------------
--- @return void
--- @param damage number
function PureDamageStat:CalculatePureDamage(target, damage)
    return MathUtils.Truncate(damage * self:GetValue())
end

--- @return string
function PureDamageStat:ToString()
    return string.format("pureDamage = %s\n", self:GetValue())
end