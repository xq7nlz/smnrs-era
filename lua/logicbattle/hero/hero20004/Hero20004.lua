--- @class Hero20004 Defronowe
Hero20004 = Class(Hero20004, BaseHero)

--- @return Hero20004
function Hero20004:CreateInstance()
    return Hero20004()
end

--- @return HeroInitializer
function Hero20004:CreateInitializer()
    return Hero20004_Initializer(self)
end

return Hero20004