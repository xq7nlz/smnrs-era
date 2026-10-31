--- @class Hero60013 DarkKnight
Hero60013 = Class(Hero60013, BaseHero)

--- @return BaseHero
function Hero60013:CreateInstance()
    return Hero60013()
end

--- @return HeroInitializer
function Hero60013:CreateInitializer()
    return Hero60013_Initializer(self)
end

return Hero60013