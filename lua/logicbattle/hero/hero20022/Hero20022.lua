--- @class Hero20022 Imp
Hero20022 = Class(Hero20022, BaseHero)

--- @return BaseHero
function Hero20022:CreateInstance()
    return Hero20022()
end

return Hero20022