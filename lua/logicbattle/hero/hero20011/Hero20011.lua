--- @class Hero20011 Labord
Hero20011 = Class(Hero20011, BaseHero)

--- @return BaseHero
function Hero20011:CreateInstance()
    return Hero20011()
end

--- @return HeroInitializer
function Hero20011:CreateInitializer()
    return Hero20011_Initializer(self)
end

return Hero20011