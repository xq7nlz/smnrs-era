--- @class Hero50023 Dancer
Hero50023 = Class(Hero50023, BaseHero)

--- @return BaseHero
function Hero50023:CreateInstance()
    return Hero50023()
end

--- @return HeroInitializer
function Hero50023:CreateInitializer()
    return Hero50023_Initializer(self)
end

return Hero50023