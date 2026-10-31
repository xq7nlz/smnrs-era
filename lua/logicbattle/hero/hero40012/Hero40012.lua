--- @class Hero40012 Lothiriel
Hero40012 = Class(Hero40012, BaseHero)

--- @return BaseHero
function Hero40012:CreateInstance()
    return Hero40012()
end

--- @return HeroInitializer
function Hero40012:CreateInitializer()
    return Hero40012_Initializer(self)
end

return Hero40012