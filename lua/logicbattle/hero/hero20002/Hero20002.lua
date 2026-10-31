--- @class Hero20002 Arien
Hero20002 = Class(Hero20002, BaseHero)

--- @return void
function Hero20002:Ctor()
    BaseHero.Ctor(self)
end

--- @return Hero20002
function Hero20002:CreateInstance()
    return Hero20002()
end

--- @return HeroInitializer
function Hero20002:CreateInitializer()
    return Hero20002_Initializer(self)
end

return Hero20002