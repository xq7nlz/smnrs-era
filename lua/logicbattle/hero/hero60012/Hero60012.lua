--- @class Hero60012 Juan
Hero60012 = Class(Hero60012, BaseHero)

--- @return BaseHero
function Hero60012:CreateInstance()
    return Hero60012()
end

--- @return HeroInitializer
function Hero60012:CreateInitializer()
    return Hero60012_Initializer(self)
end

return Hero60012