--- @class Hero10009 Lashna
Hero10009 = Class(Hero10009, BaseHero)

--- @return Hero10009
function Hero10009:CreateInstance()
    return Hero10009()
end

--- @return HeroInitializer
function Hero10009:CreateInitializer()
    return Hero10009_Initializer(self)
end

return Hero10009