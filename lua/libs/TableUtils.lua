--- @class TableUtils
TableUtils = {}

--- @return boolean key is in table or not
--- @param tableToCheck table
--- @param key object key to check
function TableUtils.IsContainKey(tableToCheck, key)
    if key == nil or tableToCheck == nil then
        return false
    end

    local item = tableToCheck[key]
    if item ~= nil then
        return true
    end

    return false
end

--- @return boolean value is in table or not
--- @param tableToCheck table
--- @param value object value to check
function TableUtils.IsContainValue(tableToCheck, value)
    if value == nil or tableToCheck == nil then
        return false
    end

    for k, _ in pairs(tableToCheck) do
        if k == value then
            return true
        end
    end
    return false
end

--- @return boolean key is in table or not
--- @param tableToCheck table
function TableUtils.CountKey(tableToCheck)
    local numberKey = 0
    for _, _ in pairs(tableToCheck) do
        numberKey = numberKey + 1
    end
    return numberKey
end

--- @return table
--- @param original table
function TableUtils.Clone(original)
    local copy
    if type(original) == 'table' then
        copy = {}
        for k, v in pairs(original) do
            copy[k] = v
        end
        setmetatable(copy, getmetatable(original))
    else
        -- number, string, boolean, etc
        copy = original
    end
    return copy
end

return TableUtils