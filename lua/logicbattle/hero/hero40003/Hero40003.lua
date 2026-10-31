--- @class Hero40003 Arryl
Hero40003 = Class(Hero40003, BaseHero)

--- @return BaseHero
function Hero40003:CreateInstance()
    return Hero40003()
end

--- @return HeroInitializer
function Hero40003:CreateInitializer()
    return Hero40003_Initializer(self)
end

return Hero40003