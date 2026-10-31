--- @class Hero50026 Fioneth
Hero50026 = Class(Hero50026, BaseHero)

--- @return BaseHero
function Hero50026:CreateInstance()
    return Hero50026()
end

--- @return HeroInitializer
function Hero50026:CreateInitializer()
    return Hero50026_Initializer(self)
end

return Hero50026