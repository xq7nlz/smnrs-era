--- @class Hero20013 Zeres
Hero20013 = Class(Hero20013, BaseHero)

--- @return BaseHero
function Hero20013:CreateInstance()
    return Hero20013()
end

--- @return HeroInitializer
function Hero20013:CreateInitializer()
    return Hero20013_Initializer(self)
end

return Hero20013