--- @class Hero50010 Sephion
Hero50010 = Class(Hero50010, BaseHero)

--- @return BaseHero
function Hero50010:CreateInstance()
    return Hero50010()
end

--- @return HeroInitializer
function Hero50010:CreateInitializer()
    return Hero50010_Initializer(self)
end

return Hero50010