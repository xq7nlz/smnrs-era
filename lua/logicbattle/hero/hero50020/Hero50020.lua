--- @class Hero50020 Soldier
Hero50020 = Class(Hero50020, BaseHero)

--- @return BaseHero
function Hero50020:CreateInstance()
    return Hero50020()
end

return Hero50020