--- @class Hero10016 Croconile
Hero10016 = Class(Hero10016, BaseHero)

--- @return Hero10014
function Hero10016:CreateInstance()
    return Hero10016()
end

--- @return HeroInitializer
function Hero10016:CreateInitializer()
    return Hero10016_Initializer(self)
end

return Hero10016