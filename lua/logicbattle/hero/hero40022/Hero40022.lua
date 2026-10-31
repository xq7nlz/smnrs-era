--- @class Hero40022 Arawen
Hero40022 = Class(Hero40022, BaseHero)

--- @return BaseHero
function Hero40022:CreateInstance()
    return Hero40022()
end

--- @return HeroInitializer
function Hero40022:CreateInitializer()
    return Hero40022_Initializer(self)
end

return Hero40022