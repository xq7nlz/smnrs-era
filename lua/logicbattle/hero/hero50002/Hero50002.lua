--- @class Hero50002 HolyKnight
Hero50002 = Class(Hero50002, BaseHero)

--- @return Hero50002
function Hero50002:CreateInstance()
    return Hero50002()
end

--- @return HeroInitializer
function Hero50002:CreateInitializer()
    return Hero50002_Initializer(self)
end

return Hero50002