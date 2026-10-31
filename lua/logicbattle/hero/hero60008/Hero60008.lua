--- @class Hero60008 Renaks
Hero60008 = Class(Hero60008, BaseHero)

--- @return BaseHero
function Hero60008:CreateInstance()
    return Hero60008()
end

--- @return HeroInitializer
function Hero60008:CreateInitializer()
    return Hero60008_Initializer(self)
end

return Hero60008