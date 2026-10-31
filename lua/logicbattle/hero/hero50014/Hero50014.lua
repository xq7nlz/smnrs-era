--- @class Hero50014 Hweston
Hero50014 = Class(Hero50014, BaseHero)

--- @return BaseHero
function Hero50014:CreateInstance()
    return Hero50014()
end

--- @return HeroInitializer
function Hero50014:CreateInitializer()
    return Hero50014_Initializer(self)
end

return Hero50014