--- @class Hero30014 Kargoth
Hero30014 = Class(Hero30014, BaseHero)

--- @return Hero30003
function Hero30014:CreateInstance()
    return Hero30014()
end

--- @return HeroInitializer
function Hero30014:CreateInitializer()
    return Hero30014_Initializer(self)
end

return Hero30014