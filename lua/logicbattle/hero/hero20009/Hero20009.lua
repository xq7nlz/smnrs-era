--- @class Hero20009 Fragnil
Hero20009 = Class(Hero20009, BaseHero)

--- @return BaseHero
function Hero20009:CreateInstance()
    return Hero20009()
end

--- @return HeroInitializer
function Hero20009:CreateInitializer()
    return Hero20009_Initializer(self)
end

return Hero20009