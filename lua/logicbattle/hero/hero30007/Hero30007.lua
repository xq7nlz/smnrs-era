--- @class Hero30007 Zygor
Hero30007 = Class(Hero30007, BaseHero)

--- @return Hero30003
function Hero30007:CreateInstance()
    return Hero30007()
end

--- @return HeroInitializer
function Hero30007:CreateInitializer()
    return Hero30007_Initializer(self)
end

return Hero30007