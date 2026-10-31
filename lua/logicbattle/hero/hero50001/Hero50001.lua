--- @class Hero50001 AmiableAngel
Hero50001 = Class(Hero50001, BaseHero)

--- @return BaseHero
function Hero50001:CreateInstance()
    return Hero50001()
end

--- @return HeroInitializer
function Hero50001:CreateInitializer()
    return Hero50001_Initializer(self)
end

return Hero50001