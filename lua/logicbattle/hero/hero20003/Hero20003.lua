--- @class Hero20003 Eitri
Hero20003 = Class(Hero20003, BaseHero)

--- @return Hero20003
function Hero20003:CreateInstance()
    return Hero20003()
end

--- @return HeroInitializer
function Hero20003:CreateInitializer()
    return Hero20003_Initializer(self)
end

return Hero20003