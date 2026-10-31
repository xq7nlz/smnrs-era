--- @class Hero10002 Sharpwater
Hero10002 = Class(Hero10002, BaseHero)

--- @return Hero10002
function Hero10002:CreateInstance()
    return Hero10002()
end

--- @return HeroInitializer
function Hero10002:CreateInitializer()
    return Hero10002_Initializer(self)
end

return Hero10002