--- @class Hero50012 Alvar
Hero50012 = Class(Hero50012, BaseHero)

--- @return BaseHero
function Hero50012:CreateInstance()
    return Hero50012()
end

--- @return HeroInitializer
function Hero50012:CreateInitializer()
    return Hero50012_Initializer(self)
end

return Hero50012