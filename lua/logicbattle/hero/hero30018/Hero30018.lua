--- @class Hero30018 DeathJester
Hero30018 = Class(Hero30018, BaseHero)

--- @return BaseHero
function Hero30018:CreateInstance()
    return Hero30018()
end

--- @return HeroInitializer
function Hero30018:CreateInitializer()
    return Hero30018_Initializer(self)
end

return Hero30018