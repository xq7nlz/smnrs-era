--- @class Hero10020 Sniper
Hero10020 = Class(Hero10020, BaseHero)

--- @return Hero10014
function Hero10020:CreateInstance()
    return Hero10020()
end

--- @return HeroInitializer
function Hero10020:CreateInitializer()
    return Hero10020_Initializer(self)
end

return Hero10020