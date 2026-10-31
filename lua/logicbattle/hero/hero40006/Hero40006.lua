--- @class Hero40006 Yang
Hero40006 = Class(Hero40006, BaseHero)

--- @return BaseHero
function Hero40006:CreateInstance()
    return Hero40006()
end

--- @return HeroInitializer
function Hero40006:CreateInitializer()
    return Hero40006_Initializer(self)
end

return Hero40006