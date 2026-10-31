--- @class CritDamageStat : BaseHeroStat
CritDamageStat = Class(CritDamageStat, BaseHeroStat)

--- @return void
--- @param hero BaseHero
function CritDamageStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.CRIT_DAMAGE, StatValueType.PERCENT)
end

---------------------------------------- Getters ----------------------------------------
--- @return boolean, number isCrit, critDamage
--- @param damage number
--- @param critRate number
function CritDamageStat:CalculateCritDamage(target, damage, critRate)
    local critDamage = damage

    local isCrit = self.myHero.randomHelper:RandomRate(critRate)
    if isCrit then
        critDamage = MathUtils.Truncate(damage * self:GetValue())
    end

    return isCrit, critDamage
end

--- @return string
function CritDamageStat:ToString()
    return string.format("critDamage = %s\n", self:GetValue())
end