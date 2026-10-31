--- @class Hero50008 Fanar
Hero50008 = Class(Hero50008, BaseHero)

--- @return BaseHero
function Hero50008:CreateInstance()
    return Hero50008()
end

--- @return HeroInitializer
function Hero50008:CreateInitializer()
    return Hero50008_Initializer(self)
end

return Hero50008