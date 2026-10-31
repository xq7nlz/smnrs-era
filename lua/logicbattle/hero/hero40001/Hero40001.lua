--- @class Hero40001 ColdAxe
Hero40001 = Class(Hero40001, BaseHero)

--- @return BaseHero
function Hero40001:CreateInstance()
    return Hero40001()
end

--- @return HeroInitializer
function Hero40001:CreateInitializer()
    return Hero40001_Initializer(self)
end

return Hero40001