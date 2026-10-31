--- @class Hero30009 Gorzodin
Hero30009 = Class(Hero30009, BaseHero)

--- @return Hero30003
function Hero30009:CreateInstance()
    return Hero30009()
end

--- @return HeroInitializer
function Hero30009:CreateInitializer()
    return Hero30009_Initializer(self)
end

return Hero30009