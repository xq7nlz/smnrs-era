--- @class Hero30002 En
Hero30002 = Class(Hero30002, BaseHero)

--- @return Hero30002
function Hero30002:CreateInstance()
    return Hero30002()
end

--- @return HeroInitializer
function Hero30002:CreateInitializer()
    return Hero30002_Initializer(self)
end

return Hero30002