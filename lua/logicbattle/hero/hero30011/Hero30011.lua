--- @class Hero30011 : BaseHero Skaven
Hero30011 = Class(Hero30011, BaseHero)

--- @return Hero30003
function Hero30011:CreateInstance()
    return Hero30011()
end

--- @return HeroInitializer
function Hero30011:CreateInitializer()
    return Hero30011_Initializer(self)
end

return Hero30011