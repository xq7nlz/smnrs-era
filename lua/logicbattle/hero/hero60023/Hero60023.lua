--- @class Hero60023 Tauren
Hero60023 = Class(Hero60023, BaseHero)

--- @return BaseHero
function Hero60023:CreateInstance()
    return Hero60023()
end

--- @return HeroInitializer
function Hero60023:CreateInitializer()
    return Hero60023_Initializer(self)
end

return Hero60023