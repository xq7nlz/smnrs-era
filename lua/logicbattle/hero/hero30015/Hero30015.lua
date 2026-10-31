--- @class Hero30015 Fang
Hero30015 = Class(Hero30015, BaseHero)

--- @return Hero30003
function Hero30015:CreateInstance()
    return Hero30015()
end

--- @return HeroInitializer
function Hero30015:CreateInitializer()
    return Hero30015_Initializer(self)
end

return Hero30015