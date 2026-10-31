--- @class Hero40005 Yang
Hero40005 = Class(Hero40005, BaseHero)

--- @return BaseHero
function Hero40005:CreateInstance()
    return Hero40005()
end

--- @return HeroInitializer
function Hero40005:CreateInitializer()
    return Hero40005_Initializer(self)
end

return Hero40005