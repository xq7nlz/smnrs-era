local LUA_PATH = "csv/client/hero_class.json"

--- @class HeroClassConfig
HeroClassConfig = Class(HeroClassConfig)

function HeroClassConfig:Ctor()
    --- @type Dictionary
    self.heroClassDict = nil
    self:Init()
end

function HeroClassConfig:Init()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(LUA_PATH, nil, true)
    self.heroClassDict = Dictionary()
    for id, class in pairs(parsedData) do
        self.heroClassDict:Add(tonumber(id), tonumber(class))
    end
end

function HeroClassConfig:GetClass(heroId)
    return self.heroClassDict:Get(heroId)
end

return HeroClassConfig