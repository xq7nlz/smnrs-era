--- @class Hero10003 Gracious Fairy
Hero10003 = Class(Hero10003, BaseHero)

--- @return Hero10003
function Hero10003:CreateInstance()
    return Hero10003()
end

--- @return HeroInitializer
function Hero10003:CreateInitializer()
    return Hero10003_Initializer(self)
end

return Hero10003