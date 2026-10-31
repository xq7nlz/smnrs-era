--- @class StatChangerCalculationType
StatChangerCalculationType = {
    PERCENT_ADD = 1,
    PERCENT_MULTIPLY = 2,
    RAW_ADD_BASE = 3,
    RAW_ADD_IN_GAME = 4,
}

--- @return boolean
function StatChangerCalculationType.IsValidType(type)
    if StatChangerCalculationType.PERCENT_ADD <= type and type <= StatChangerCalculationType.RAW_ADD_IN_GAME then
        return true
    end

    return false
end

return StatChangerCalculationType