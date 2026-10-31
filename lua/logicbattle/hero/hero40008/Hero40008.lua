--- @class Hero40008 Lass
Hero40008 = Class(Hero40008, BaseHero)

--- @return BaseHero
function Hero40008:CreateInstance()
    return Hero40008()
end

--- @return HeroInitializer
function Hero40008:CreateInitializer()
    return Hero40008_Initializer(self)
end

return Hero40008