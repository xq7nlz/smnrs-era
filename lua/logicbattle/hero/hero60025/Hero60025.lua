--- @class Hero60025 Vampire
Hero60025 = Class(Hero60025, BaseHero)

--- @return BaseHero
function Hero60025:CreateInstance()
    return Hero60025()
end

return Hero60025