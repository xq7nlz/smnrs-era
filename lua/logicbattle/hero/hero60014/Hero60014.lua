--- @class Hero60014 ShiShil
Hero60014 = Class(Hero60014, BaseHero)

--- @return BaseHero
function Hero60014:CreateInstance()
    return Hero60014()
end

--- @return HeroInitializer
function Hero60014:CreateInitializer()
    return Hero60014_Initializer(self)
end

return Hero60014