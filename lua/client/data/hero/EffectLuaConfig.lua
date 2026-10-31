local CLIENT_LUA_FILE_PATH = "csv/client/client_lua_config_file_name.json"

--- @class EffectLuaConfig
EffectLuaConfig = Class(EffectLuaConfig)

function EffectLuaConfig:Ctor()
    --- @type Dictionary
    self.luaRequireDict = nil
    self:Init()
end

function EffectLuaConfig:Init()
    local decodeData = CsvReaderUtils.ReadAndParseLocalFile(CLIENT_LUA_FILE_PATH, nil, true)
    self.luaRequireDict = Dictionary()
    for fileName, luaFileName in pairs(decodeData) do
        self.luaRequireDict:Add(fileName, string.format("lua.client.battleShow.ClientEffectConfig.%s", luaFileName))
    end
end

function EffectLuaConfig:Get(name)
    return self.luaRequireDict:Get(name)
end

return EffectLuaConfig