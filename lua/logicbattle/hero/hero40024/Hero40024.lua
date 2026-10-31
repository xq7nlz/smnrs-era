--- @class Hero40024 Wugushi
Hero40024 = Class(Hero40024, BaseHero)

--- @return BaseHero
function Hero40024:CreateInstance()
    return Hero40024()
end

--- @return HeroInitializer
function Hero40024:CreateInitializer()
    return Hero40024_Initializer(self)
end

return Hero40024