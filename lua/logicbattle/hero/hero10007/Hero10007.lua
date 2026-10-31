--- @class Hero10007 Osse
Hero10007 = Class(Hero10007, BaseHero)

--- @return Hero10007
function Hero10007:CreateInstance()
    return Hero10007()
end

--- @return HeroInitializer
function Hero10007:CreateInitializer()
    return Hero10007_Initializer(self)
end

return Hero10007