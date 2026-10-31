--- @class Hero20026 Kardoh
Hero20026 = Class(Hero20026, BaseHero)

--- @return BaseHero
function Hero20026:CreateInstance()
    return Hero20026()
end

--- @return HeroInitializer
function Hero20026:CreateInitializer()
    return Hero20026_Initializer(self)
end

return Hero20026