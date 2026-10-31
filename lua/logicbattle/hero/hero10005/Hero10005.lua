--- @class Hero10005 Mist
Hero10005 = Class(Hero10005, BaseHero)

--- @return Hero10005
function Hero10005:CreateInstance()
    return Hero10005()
end

--- @return HeroInitializer
function Hero10005:CreateInitializer()
    return Hero10005_Initializer(self)
end

return Hero10005