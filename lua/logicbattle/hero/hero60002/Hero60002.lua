--- @class Hero60002 Bloodseeker
Hero60002 = Class(Hero60002, BaseHero)

--- @return BaseHero
function Hero60002:CreateInstance()
    return Hero60002()
end

--- @return HeroInitializer
function Hero60002:CreateInitializer()
    return Hero60002_Initializer(self)
end

return Hero60002