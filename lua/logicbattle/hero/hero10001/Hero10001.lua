--- @class Hero10001 ColdAxe
Hero10001 = Class(Hero10001, BaseHero)

--- @return Hero10001
function Hero10001:CreateInstance()
    return Hero10001()
end

--- @return HeroInitializer
function Hero10001:CreateInitializer()
    return Hero10001_Initializer(self)
end

return Hero10001