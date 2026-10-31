--- @class Hero50013 Celes
Hero50013 = Class(Hero50013, BaseHero)

--- @return BaseHero
function Hero50013:CreateInstance()
    return Hero50013()
end

--- @return HeroInitializer
function Hero50013:CreateInitializer()
    return Hero50013_Initializer(self)
end

return Hero50013