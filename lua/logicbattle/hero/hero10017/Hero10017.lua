--- @class Hero10017 Glugrgly
Hero10017 = Class(Hero10017, BaseHero)

--- @return Hero10014
function Hero10017:CreateInstance()
    return Hero10017()
end

--- @return HeroInitializer
function Hero10017:CreateInitializer()
    return Hero10017_Initializer(self)
end

return Hero10017