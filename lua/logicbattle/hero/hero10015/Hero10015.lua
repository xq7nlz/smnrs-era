--- @class Hero10015 Aesa
Hero10015 = Class(Hero10015, BaseHero)

--- @return Hero10014
function Hero10015:CreateInstance()
    return Hero10015()
end

--- @return HeroInitializer
function Hero10015:CreateInitializer()
    return Hero10015_Initializer(self)
end

return Hero10015