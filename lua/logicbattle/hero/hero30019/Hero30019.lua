--- @class Hero30019 Elne
Hero30019 = Class(Hero30019, BaseHero)

--- @return BaseHero
function Hero30019:CreateInstance()
    return Hero30019()
end

--- @return HeroInitializer
function Hero30019:CreateInitializer()
    return Hero30019_Initializer(self)
end

return Hero30019