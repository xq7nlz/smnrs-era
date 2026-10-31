--- @class Hero20025 Yirlal
Hero20025 = Class(Hero20025, BaseHero)

--- @return BaseHero
function Hero20025:CreateInstance()
    return Hero20025()
end

--- @return HeroInitializer
function Hero20025:CreateInitializer()
    return Hero20025_Initializer(self)
end

return Hero20025