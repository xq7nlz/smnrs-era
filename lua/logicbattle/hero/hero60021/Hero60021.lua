--- @class Hero60021 DarkArcher
Hero60021 = Class(Hero60021, BaseHero)

--- @return BaseHero
function Hero60021:CreateInstance()
    return Hero60021()
end

--- @return HeroInitializer
function Hero60021:CreateInitializer()
    return Hero60021_Initializer(self)
end

return Hero60021