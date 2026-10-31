--- @class Hero30021 EarthMaster
Hero30021 = Class(Hero30021, BaseHero)

--- @return BaseHero
function Hero30021:CreateInstance()
    return Hero30021()
end

--- @return HeroInitializer
function Hero30021:CreateInitializer()
    return Hero30021_Initializer(self)
end

return Hero30021