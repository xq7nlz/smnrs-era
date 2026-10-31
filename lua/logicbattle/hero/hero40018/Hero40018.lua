--- @class Hero40018 Oakroot
Hero40018 = Class(Hero40018, BaseHero)

--- @return BaseHero
function Hero40018:CreateInstance()
    return Hero40018()
end

--- @return HeroInitializer
function Hero40018:CreateInitializer()
    return Hero40018_Initializer(self)
end

return Hero40018