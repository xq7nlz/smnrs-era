--- @class Hero30024 Ozroth
Hero30024 = Class(Hero30024, BaseHero)

--- @return BaseHero
function Hero30024:CreateInstance()
    return Hero30024()
end

--- @return HeroInitializer
function Hero30024:CreateInitializer()
    return Hero30024_Initializer(self)
end

return Hero30024