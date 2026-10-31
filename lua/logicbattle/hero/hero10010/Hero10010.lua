--- @class Hero10010 Japulan
Hero10010 = Class(Hero10010, BaseHero)

--- @return Hero10010
function Hero10010:CreateInstance()
    return Hero10010()
end

--- @return HeroInitializer
function Hero10010:CreateInitializer()
    return Hero10010_Initializer(self)
end

return Hero10010