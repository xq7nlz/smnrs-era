--- @class Hero40002 Yggra
Hero40002 = Class(Hero40002, BaseHero)

--- @return BaseHero
function Hero40002:CreateInstance()
    return Hero40002()
end

--- @return HeroInitializer
function Hero40002:CreateInitializer()
    return Hero40002_Initializer(self)
end

return Hero40002