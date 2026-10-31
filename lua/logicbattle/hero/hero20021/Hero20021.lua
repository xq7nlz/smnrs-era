--- @class Hero20021 Cain
Hero20021 = Class(Hero20021, BaseHero)

--- @return BaseHero
function Hero20021:CreateInstance()
    return Hero20021()
end

return Hero20021