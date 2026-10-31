--- @class Hero10004 Frosthardy
Hero10004 = Class(Hero10004, BaseHero)

--- @return Hero10004
function Hero10004:CreateInstance()
    return Hero10004()
end

--- @return HeroInitializer
function Hero10004:CreateInitializer()
    return Hero10004_Initializer(self)
end

return Hero10004