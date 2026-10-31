--- @class Hero40026 Neyuh
Hero40026 = Class(Hero40026, BaseHero)

--- @return BaseHero
function Hero40026:CreateInstance()
    return Hero40026()
end

--- @return HeroInitializer
function Hero40026:CreateInitializer()
    return Hero40026_Initializer(self)
end

return Hero40026