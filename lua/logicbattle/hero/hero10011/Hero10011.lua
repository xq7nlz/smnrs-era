--- @class Hero10011 Jeronim
Hero10011 = Class(Hero10011, BaseHero)

--- @return Hero10011
function Hero10011:CreateInstance()
    return Hero10011()
end

--- @return HeroInitializer
function Hero10011:CreateInitializer()
    return Hero10011_Initializer(self)
end

return Hero10011