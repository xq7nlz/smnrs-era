--- @class Hero50025 Avorn
Hero50025 = Class(Hero50025, BaseHero)

--- @return BaseHero
function Hero50025:CreateInstance()
    return Hero50025()
end

--- @return HeroInitializer
function Hero50025:CreateInitializer()
    return Hero50025_Initializer(self)
end

return Hero50025