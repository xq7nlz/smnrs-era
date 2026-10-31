--- @class Hero20016 Ifrit
Hero20016 = Class(Hero20016, BaseHero)

--- @return Hero20016
function Hero20016:CreateInstance()
    return Hero20016()
end

--- @return HeroInitializer
function Hero20016:CreateInitializer()
    return Hero20016_Initializer(self)
end

return Hero20016