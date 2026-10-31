--- @class SpeedStat : BaseHeroStat
SpeedStat = Class(SpeedStat, BaseHeroStat)

--- @return void
--- @param hero BaseHero
function SpeedStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.SPEED, StatValueType.RAW)
end

--- @return string
function SpeedStat:ToString()
    return string.format("speed = %s\n", self:GetValue())
end