--- @class Hero20007 Ninetales
Hero20007 = Class(Hero20007, BaseHero)

--- @return BaseHero
function Hero20007:CreateInstance()
    return Hero20007()
end

--- @return HeroInitializer
function Hero20007:CreateInitializer()
    return Hero20007_Initializer(self)
end

return Hero20007