--- @class Hero30001 Charon
Hero30001 = Class(Hero30001, BaseHero)

--- @return Hero30001
function Hero30001:CreateInstance()
    return Hero30001()
end

--- @return HeroInitializer
function Hero30001:CreateInitializer()
    return Hero30001_Initializer(self)
end

return Hero30001