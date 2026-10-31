--- @class Hero40010 Yome
Hero40010 = Class(Hero40010, BaseHero)

--- @return BaseHero
function Hero40010:CreateInstance()
    return Hero40010()
end

--- @return HeroInitializer
function Hero40010:CreateInitializer()
    return Hero40010_Initializer(self)
end

return Hero40010