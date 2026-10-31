--- @class Hero60022 DeadServant
Hero60022 = Class(Hero60022, BaseHero)

--- @return BaseHero
function Hero60022:CreateInstance()
    return Hero60022()
end

--- @return HeroInitializer
function Hero60022:CreateInitializer()
    return Hero60022_Initializer(self)
end

return Hero60022