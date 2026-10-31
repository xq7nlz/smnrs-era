--- @class Hero10006 Aqualord
Hero10006 = Class(Hero10006, BaseHero)

--- @return Hero10006
function Hero10006:CreateInstance()
    return Hero10006()
end

--- @return HeroInitializer
function Hero10006:CreateInitializer()
    return Hero10006_Initializer(self)
end

return Hero10006