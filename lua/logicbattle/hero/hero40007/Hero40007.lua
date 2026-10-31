--- @class Hero40007 Noroth
Hero40007 = Class(Hero40007, BaseHero)

--- @return BaseHero
function Hero40007:CreateInstance()
    return Hero40007()
end

--- @return HeroInitializer
function Hero40007:CreateInitializer()
    return Hero40007_Initializer(self)
end

return Hero40007