--- @class Hero50022 Elf
Hero50022 = Class(Hero50022, BaseHero)

--- @return BaseHero
function Hero50022:CreateInstance()
    return Hero50022()
end

return Hero50022