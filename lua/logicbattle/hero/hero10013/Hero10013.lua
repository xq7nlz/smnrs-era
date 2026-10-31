--- @class Hero10013 Oceanee
Hero10013 = Class(Hero10013, BaseHero)

--- @return Hero10013
function Hero10013:CreateInstance()
    return Hero10013()
end

--- @return HeroInitializer
function Hero10013:CreateInitializer()
    return Hero10013_Initializer(self)
end

return Hero10013