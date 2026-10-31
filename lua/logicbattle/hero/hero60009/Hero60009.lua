--- @class Hero60009 Khann
Hero60009 = Class(Hero60009, BaseHero)

--- @return BaseHero
function Hero60009:CreateInstance()
    return Hero60009()
end

--- @return HeroInitializer
function Hero60009:CreateInitializer()
    return Hero60009_Initializer(self)
end

return Hero60009