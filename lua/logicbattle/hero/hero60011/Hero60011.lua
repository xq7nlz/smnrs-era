--- @class Hero60011 Vera
Hero60011 = Class(Hero60011, BaseHero)

--- @return BaseHero
function Hero60011:CreateInstance()
    return Hero60011()
end

--- @return HeroInitializer
function Hero60011:CreateInitializer()
    return Hero60011_Initializer(self)
end

return Hero60011