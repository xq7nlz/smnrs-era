--- @class Hero50007 Celestia
Hero50007 = Class(Hero50007, BaseHero)

--- @return BaseHero
function Hero50007:CreateInstance()
    return Hero50007()
end

--- @return HeroInitializer
function Hero50007:CreateInitializer()
    return Hero50007_Initializer(self)
end

return Hero50007