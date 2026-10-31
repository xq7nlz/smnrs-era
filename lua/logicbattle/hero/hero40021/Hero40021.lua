--- @class Hero40021 Lith
Hero40021 = Class(Hero40021, BaseHero)

--- @return BaseHero
function Hero40021:CreateInstance()
    return Hero40021()
end

--- @return HeroInitializer
function Hero40021:CreateInitializer()
    return Hero40021_Initializer(self)
end

return Hero40021