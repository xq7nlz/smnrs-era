--- @class Hero60004 Karos
Hero60004 = Class(Hero60004, BaseHero)

--- @return BaseHero
function Hero60004:CreateInstance()
    return Hero60004()
end

--- @return HeroInitializer
function Hero60004:CreateInitializer()
    return Hero60004_Initializer(self)
end

return Hero60004