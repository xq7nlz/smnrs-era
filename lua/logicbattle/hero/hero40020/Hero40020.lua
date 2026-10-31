--- @class Hero40020 Lith
Hero40020 = Class(Hero40020, BaseHero)

--- @return BaseHero
function Hero40020:CreateInstance()
    return Hero40020()
end

--- @return HeroInitializer
function Hero40020:CreateInitializer()
    return Hero40020_Initializer(self)
end

return Hero40020