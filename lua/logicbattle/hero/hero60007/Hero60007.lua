--- @class Hero60007 Rannantos
Hero60007 = Class(Hero60007, BaseHero)

--- @return BaseHero
function Hero60007:CreateInstance()
    return Hero60007()
end

--- @return HeroInitializer
function Hero60007:CreateInitializer()
    return Hero60007_Initializer(self)
end

return Hero60007