--- @class Hero20015 Rufus
Hero20015 = Class(Hero20015, BaseHero)

--- @return BaseHero
function Hero20015:CreateInstance()
    return Hero20015()
end

--- @return HeroInitializer
function Hero20015:CreateInitializer()
    return Hero20015_Initializer(self)
end

return Hero20015