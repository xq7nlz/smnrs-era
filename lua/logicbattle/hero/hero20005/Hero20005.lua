--- @class Hero20005 Yin
Hero20005 = Class(Hero20005, BaseHero)

--- @return BaseHero
function Hero20005:CreateInstance()
    return Hero20005()
end

--- @return HeroInitializer
function Hero20005:CreateInitializer()
    return Hero20005_Initializer(self)
end

return Hero20005