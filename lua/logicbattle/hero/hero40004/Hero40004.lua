--- @class Hero40004 Cennunos
Hero40004 = Class(Hero40004, BaseHero)

--- @return BaseHero
function Hero40004:CreateInstance()
    return Hero40004()
end

--- @return HeroInitializer
function Hero40004:CreateInitializer()
    return Hero40004_Initializer(self)
end

return Hero40004