--- @class DefenseStat : BaseHeroStatIntegral
DefenseStat = Class(DefenseStat, BaseHeroStatIntegral)

--- @return void
--- @param hero BaseHero
function DefenseStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.DEFENSE, StatValueType.RAW)
end

--- @return string
function DefenseStat:ToString()
    return string.format("defense = %s\n", self:GetValue())
end