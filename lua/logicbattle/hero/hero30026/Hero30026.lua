--- @class Hero30026 Vlad
Hero30026 = Class(Hero30026, BaseHero)

--- @return BaseHero
function Hero30026:CreateInstance()
    return Hero30026()
end

--- @return HeroInitializer
function Hero30026:CreateInitializer()
    return Hero30026_Initializer(self)
end

return Hero30026