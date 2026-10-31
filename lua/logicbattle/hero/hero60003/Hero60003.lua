--- @class Hero60003 ShadowBlade
Hero60003 = Class(Hero60003, BaseHero)

--- @return BaseHero
function Hero60003:CreateInstance()
    return Hero60003()
end

--- @return HeroInitializer
function Hero60003:CreateInitializer()
    return Hero60003_Initializer(self)
end

return Hero60003