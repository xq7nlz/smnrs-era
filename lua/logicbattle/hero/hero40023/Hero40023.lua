--- @class Hero40023 Hound Master
Hero40023 = Class(Hero40023, BaseHero)

--- @return BaseHero
function Hero40023:CreateInstance()
    return Hero40023()
end

--- @return HeroInitializer
function Hero40023:CreateInitializer()
    return Hero40023_Initializer(self)
end

return Hero40023