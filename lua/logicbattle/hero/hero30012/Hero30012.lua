--- @class Hero30012 Dzuteh
Hero30012 = Class(Hero30012, BaseHero)

--- @return Hero30003
function Hero30012:CreateInstance()
    return Hero30012()
end

--- @return HeroInitializer
function Hero30012:CreateInitializer()
    return Hero30012_Initializer(self)
end

return Hero30012