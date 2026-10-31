--- @class Hero60005 Karos
Hero60005 = Class(Hero60005, BaseHero)

--- @return BaseHero
function Hero60005:CreateInstance()
    return Hero60005()
end

--- @return HeroInitializer
function Hero60005:CreateInitializer()
    return Hero60005_Initializer(self)
end

return Hero60005