--- @class Hero50006 Enule
Hero50006 = Class(Hero50006, BaseHero)

--- @return Hero20003
function Hero50006:CreateInstance()
    return Hero50006()
end

--- @return HeroInitializer
function Hero50006:CreateInitializer()
    return Hero50006_Initializer(self)
end

return Hero50006