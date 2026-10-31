--- @class Hero60006 Hehta
Hero60006 = Class(Hero60006, BaseHero)

--- @return BaseHero
function Hero60006:CreateInstance()
    return Hero60006()
end

--- @return HeroInitializer
function Hero60006:CreateInitializer()
    return Hero60006_Initializer(self)
end

return Hero60006