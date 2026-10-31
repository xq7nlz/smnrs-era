--- @class Hero30023 DrPlague
Hero30023 = Class(Hero30023, BaseHero)

--- @return BaseHero
function Hero30023:CreateInstance()
    return Hero30023()
end

--- @return HeroInitializer
function Hero30023:CreateInitializer()
    return Hero30023_Initializer(self)
end

return Hero30023