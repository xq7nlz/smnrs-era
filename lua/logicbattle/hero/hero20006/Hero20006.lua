--- @class Hero20006 Finde
Hero20006 = Class(Hero20006, BaseHero)

--- @return Hero20006
function Hero20006:CreateInstance()
    return Hero20006()
end

--- @return HeroInitializer
function Hero20006:CreateInitializer()
    return Hero20006_Initializer(self)
end

return Hero20006