--- @class LogUtils
LogUtils = {}

--- @return string
--- @param obj object
--- @param includeMetaTable boolean
function LogUtils.ToDetail(obj, includeMetaTable)
    if includeMetaTable == nil then
        includeMetaTable = false
    end

    local result = ""
    if obj == nil then
        result = string.format("nil (nil)")
    else
        if type(obj) == "table" then
            --- print table
            result = string.format("%s (%s)", tostring(obj), type(obj))
            for k, v in pairs(obj) do
                result = result .. string.format("\n\t[%s (%s)] = %s (%s)", tostring(k), type(k), tostring(v), type(v))
            end

            --- print meta table
            if includeMetaTable then
                local metaTable = getmetatable(obj)
                if metaTable == nil then
                    result = result .. string.format("\tnil (metaTable)")
                else
                    result = result .. string.format("\t%s (metaTable)", tostring(metaTable))
                    for k, v in pairs(metaTable) do
                        result = result .. string.format("\n\t[%s (%s)] = %s (%s)", tostring(k), type(k), tostring(v), type(v))
                    end
                end
            end
        else
            result = string.format("%s (%s)", tostring(obj), type(obj))
        end
    end

    return result
end

return LogUtils