--- @class Hero20010 Ungoliant
Hero20010 = Class(Hero20010, BaseHero)

--- @return BaseHero
function Hero20010:CreateInstance()
    return Hero20010()
end

--- @return HeroInitializer
function Hero20010:CreateInitializer()
    return Hero20010_Initializer(self)
end

return Hero20010