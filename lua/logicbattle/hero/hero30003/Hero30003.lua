--- @class Hero30003 Nero
Hero30003 = Class(Hero30003, BaseHero)

--- @return void
function Hero30003:Ctor()
    BaseHero.Ctor(self)

    --- @type boolean
    self.isPuppet = false
end

--- @return Hero30003
function Hero30003:CreateInstance()
    return Hero30003()
end

--- @return HeroInitializer
function Hero30003:CreateInitializer()
    return Hero30003_Initializer(self)
end

return Hero30003