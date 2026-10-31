--- @class Hero50021 Archer
Hero50021 = Class(Hero50021, BaseHero)

--- @return BaseHero
function Hero50021:CreateInstance()
    return Hero50021()
end

return Hero50021