--- @class Hero10008 Mammusk
Hero10008 = Class(Hero10008, BaseHero)

--- @return Hero10008
function Hero10008:CreateInstance()
    return Hero10008()
end

--- @return HeroInitializer
function Hero10008:CreateInitializer()
    return Hero10008_Initializer(self)
end

return Hero10008