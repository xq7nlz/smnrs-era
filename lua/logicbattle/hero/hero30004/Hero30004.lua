--- @class Hero30004 Stheno
Hero30004 = Class(Hero30004, BaseHero)

--- @return Hero30003
function Hero30004:CreateInstance()
    return Hero30004()
end

--- @return HeroInitializer
function Hero30004:CreateInitializer()
    return Hero30004_Initializer(self)
end

return Hero30004