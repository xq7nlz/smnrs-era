--- @class Hero30010 Erde
Hero30010 = Class(Hero30010, BaseHero)

--- @return Hero30010
function Hero30010:CreateInstance()
    return Hero30010()
end

--- @return HeroInitializer
function Hero30010:CreateInitializer()
    return Hero30010_Initializer(self)
end

return Hero30010