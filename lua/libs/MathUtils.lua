require "lua.libs.StringUtils"

--- @class MathUtils
MathUtils = {}

MathUtils.BILLION = 10 ^ 9

--- @return boolean
--- @param input object
function MathUtils.IsNumber(input)
    return type(input) == "number"
end

--- @return boolean
--- @param input object
function MathUtils.IsBoolean(input)
    return type(input) == "boolean"
end

--- @return boolean
--- @param input object
function MathUtils.IsInteger(input)
    return type(input) == "number" and math.floor(input) == input
end

--- @return boolean
--- @param input string
function MathUtils.ToBoolean(input)
    local upper = string.upper(StringUtils.Trim(input))
    if upper == "TRUE" then
        return true
    else
        return false
    end
end

--- @return number
--- @param input number
function MathUtils.Round(input)
    return input % 1 >= 0.5 and math.ceil(input) or math.floor(input)
end

--- @return number
--- @param input number
function MathUtils.RoundDecimal(input, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 2) .. "f", input))
end

--- @return number
--- @param input number
function MathUtils.Truncate(input)
    -- round to 3 digits
    return MathUtils.Round(input * 1000) / 1000
end

--- @return number
--- @param value number
--- @param min number
--- @param max number
function MathUtils.Clamp(value, min, max)
    if value < min then
        value = min
    elseif value > max then
        value = max
    end
    return value
end

--- @return number
--- @param value number
function MathUtils.Sign(value)
    if value >= 0 then
        return 1
    else
        return -1
    end
end

return MathUtils