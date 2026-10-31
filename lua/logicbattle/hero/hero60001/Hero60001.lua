--- @class Hero60001 BlackArrow
Hero60001 = Class(Hero60001, BaseHero)

--- @return BaseHero
function Hero60001:CreateInstance()
    return Hero60001()
end

--- @return HeroInitializer
function Hero60001:CreateInitializer()
    return Hero60001_Initializer(self)
end

return Hero60001