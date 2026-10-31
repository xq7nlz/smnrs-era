--- @class Hero30013 Minimanser
Hero30013 = Class(Hero30013, BaseHero)

--- @return Hero30003
function Hero30013:CreateInstance()
    return Hero30013()
end

--- @return HeroInitializer
function Hero30013:CreateInitializer()
    return Hero30013_Initializer(self)
end

return Hero30013