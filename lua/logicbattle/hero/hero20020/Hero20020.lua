--- @class Hero20020 Ira
Hero20020 = Class(Hero20020, BaseHero)

--- @return BaseHero
function Hero20020:CreateInstance()
    return Hero20020()
end

--- @return HeroInitializer
function Hero20020:CreateInitializer()
    return Hero20020_Initializer(self)
end

return Hero20020