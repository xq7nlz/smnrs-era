--- @class Hero20008 Moblin
Hero20008 = Class(Hero20008, BaseHero)

--- @return BaseHero
function Hero20008:CreateInstance()
    return Hero20008()
end

--- @return HeroInitializer
function Hero20008:CreateInitializer()
    return Hero20008_Initializer(self)
end

return Hero20008