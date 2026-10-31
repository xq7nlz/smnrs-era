--- @class Hero50005 GuardianOfLight
Hero50005 = Class(Hero50005, BaseHero)

--- @return Hero50002
function Hero50005:CreateInstance()
    return Hero50005()
end

--- @return HeroInitializer
function Hero50005:CreateInitializer()
    return Hero50005_Initializer(self)
end

return Hero50005