--- @class Hero20024 Yasin
Hero20024 = Class(Hero20024, BaseHero)

--- @return BaseHero
function Hero20024:CreateInstance()
    return Hero20024()
end

--- @return HeroInitializer
function Hero20024:CreateInitializer()
    return Hero20024_Initializer(self)
end

return Hero20024