--- @class Hero40011 Yome
Hero40011 = Class(Hero40011, BaseHero)

--- @return BaseHero
function Hero40011:CreateInstance()
    return Hero40011()
end

--- @return HeroInitializer
function Hero40011:CreateInitializer()
    return Hero40011_Initializer(self)
end

return Hero40011