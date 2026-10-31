--- @class AccuracyStat : BaseHeroStat
AccuracyStat = Class(AccuracyStat, BaseHeroStat)

--- @return void
--- @param hero BaseHero
function AccuracyStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.ACCURACY, StatValueType.RAW)
end

--- @return string
function AccuracyStat:ToString()
    return string.format("accuracy = %s\n", self:GetValue())
end