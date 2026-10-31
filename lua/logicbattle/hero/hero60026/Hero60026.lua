--- @class Hero60026 Ghunon
Hero60026 = Class(Hero60026, BaseHero)

--- @return BaseHero
function Hero60026:CreateInstance()
    return Hero60026()
end

--- @return HeroInitializer
function Hero60026:CreateInitializer()
    return Hero60026_Initializer(self)
end

return Hero60026