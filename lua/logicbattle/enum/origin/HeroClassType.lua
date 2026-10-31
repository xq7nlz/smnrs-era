--- @class HeroClassType
HeroClassType = {
    MAGE = 1,
    WARRIOR = 2,
    PRIEST = 3,
    ASSASSIN = 4,
    RANGER = 5
}

--- @return boolean
function HeroClassType.IsValidType(type)
    if HeroClassType.MAGE <= type and type <= HeroClassType.RANGER then
        return true
    end

    return false
end

return HeroClassType