--- @class Hero30005 Jormungand
Hero30005 = Class(Hero30005, BaseHero)

--- @return Hero30003
function Hero30005:CreateInstance()
    return Hero30005()
end

--- @return HeroInitializer
function Hero30005:CreateInitializer()
    return Hero30005_Initializer(self)
end

return Hero30005