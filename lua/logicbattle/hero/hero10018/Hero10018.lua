--- @class Hero10018 Sabertusk
Hero10018 = Class(Hero10018, BaseHero)

--- @return Hero10014
function Hero10018:CreateInstance()
    return Hero10018()
end

--- @return HeroInitializer
function Hero10018:CreateInitializer()
    return Hero10018_Initializer(self)
end

return Hero10018