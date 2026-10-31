local HERO_LUA_PATH = "csv/client/lua_hero_config.json"

--- @class HeroLuaConfig
HeroLuaConfig = Class(HeroLuaConfig)

function HeroLuaConfig:Ctor()
    --- @type Dictionary
    self.luaRequireDict = nil
    self:Init()
end

function HeroLuaConfig:Init()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(HERO_LUA_PATH, nil, true)
    self.luaRequireDict = Dictionary()
    for _, data in ipairs(parsedData) do
        self.luaRequireDict:Add(data['heroId'], data['heroConfigs'])
    end
end

function HeroLuaConfig:Get(heroId)
    local data = self.luaRequireDict:Get(heroId)
    if data == nil then
        XDebug.Error(string.format("heroId is nil: %s", tostring(heroId)))
    end
    return data
end

return HeroLuaConfig