--- @class Hero50024 Dwarf
Hero50024 = Class(Hero50024, BaseHero)

--- @return BaseHero
function Hero50024:CreateInstance()
    return Hero50024()
end

--- @return HeroInitializer
function Hero50024:CreateInitializer()
    return Hero50024_Initializer(self)
end

return Hero50024