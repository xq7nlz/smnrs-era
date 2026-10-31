--- @class Hero60010 Renaks
Hero60010 = Class(Hero60010, BaseHero)

--- @return BaseHero
function Hero60010:CreateInstance()
    return Hero60010()
end

--- @return HeroInitializer
function Hero60010:CreateInitializer()
    return Hero60010_Initializer(self)
end

return Hero60010