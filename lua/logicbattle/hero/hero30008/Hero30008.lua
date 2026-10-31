--- @class Hero30008 Kozorg
Hero30008 = Class(Hero30008, BaseHero)

--- @return Hero30003
function Hero30008:CreateInstance()
    return Hero30008()
end

--- @return HeroInitializer
function Hero30008:CreateInitializer()
    return Hero30008_Initializer(self)
end

return Hero30008