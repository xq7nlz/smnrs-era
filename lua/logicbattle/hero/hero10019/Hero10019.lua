--- @class Hero10019 Tidus
Hero10019 = Class(Hero10019, BaseHero)

--- @return Hero10014
function Hero10019:CreateInstance()
    return Hero10019()
end

--- @return HeroInitializer
function Hero10019:CreateInitializer()
    return Hero10019_Initializer(self)
end

return Hero10019