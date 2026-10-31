--- @class Hero60015 Murath
Hero60015 = Class(Hero60015, BaseHero)

--- @return BaseHero
function Hero60015:CreateInstance()
    return Hero60015()
end

--- @return HeroInitializer
function Hero60015:CreateInitializer()
    return Hero60015_Initializer(self)
end

return Hero60015