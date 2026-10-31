require "lua.libs.CsvReader"

local open = io.open

--- @class CsvReaderUtils
CsvReaderUtils = {}

--- @return string
--- @param path string
function CsvReaderUtils.ReadFile(path)
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

--- @return string or nil
--- @param path string
function CsvReaderUtils.ReadLocalFile(path)
    if path == nil then
        XDebug.Error("Path is nil")
        return nil
    end

    local content
    local persistentPath
    if IS_MOBILE_PLATFORM then
        if IS_ANDROID_PLATFORM then
            persistentPath = string.format("%s%s", zgUnity.UrlLua, string.gsub(path, "csv\\", "csv/"))
        else
            persistentPath = string.format("%s%s", zgUnity.UrlLua, path)
        end
    else
        local index = string.find(path, "XLua")
        if index == nil then
            persistentPath = string.format("%s%s", zgUnity.UrlLua, path)
        else
            persistentPath = string.format("%s%s", zgUnity.UrlLua, string.sub(path, 5))
        end
    end
    content = CsvReaderUtils.ReadFile(persistentPath)
    if content == nil then
        path = string.sub(path, 1, string.find(path, "%.") - 1)
        ---@type UnityEngine_TextAsset
        local textAsset = U_Resources.Load(path, ComponentName.UnityEngine_TextAsset)
        if textAsset == nil then
            print(string.format("[CsvReaderUtils] Failed: %s", path))
            return nil
        end
        content = textAsset.text
    end
    return content
end

--- @return table
--- @param path string
--- @param sep string
--- @param isJson boolean
function CsvReaderUtils.ReadAndParseLocalFile(path, sep, isJson)
    local content = CsvReaderUtils.ReadLocalFile(path)
    if content ~= nil then
        if isJson then
            return json.decode(content)
        else
            return CsvReader.ReadContent(content, sep)
        end
    end
    return nil
end

