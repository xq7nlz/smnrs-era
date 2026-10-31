--- @class Hero50003 LifeKeeper
Hero50003 = Class(Hero50003, BaseHero)

--- @return Hero50002
function Hero50003:CreateInstance()
    return Hero50003()
end

--- @return HeroInitializer
function Hero50003:CreateInitializer()
    return Hero50003_Initializer(self)
end

return Hero50003