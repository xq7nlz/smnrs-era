--- @class Hero40019 Lith
Hero40019 = Class(Hero40019, BaseHero)

--- @return BaseHero
function Hero40019:CreateInstance()
    return Hero40019()
end

--- @return HeroInitializer
function Hero40019:CreateInitializer()
    return Hero40019_Initializer(self)
end

return Hero40019