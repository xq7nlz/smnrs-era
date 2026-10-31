--- @class Hero20012 Sharon
Hero20012 = Class(Hero20012, BaseHero)

--- @return BaseHero
function Hero20012:CreateInstance()
    return Hero20012()
end

--- @return HeroInitializer
function Hero20012:CreateInitializer()
    return Hero20012_Initializer(self)
end

return Hero20012