--- @class Hero50009 Aris
Hero50009 = Class(Hero50009, BaseHero)

--- @return BaseHero
function Hero50009:CreateInstance()
    return Hero50009()
end

--- @return HeroInitializer
function Hero50009:CreateInitializer()
    return Hero50009_Initializer(self)
end

return Hero50009