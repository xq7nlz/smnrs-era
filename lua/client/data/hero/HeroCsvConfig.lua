local HERO_CSV_PATH = "csv/client/csv_hero_config.json"

--- @class HeroCsvConfig
HeroCsvConfig = Class(HeroCsvConfig)

function HeroCsvConfig:Ctor()
    --- @type Dictionary
    self.csvRequireDict = nil
    self.heroCsvContentDict = Dictionary()
    self.skillCsvContentDict = Dictionary()
end

--- @return void
function HeroCsvConfig:Init()
    self.csvRequireDict = {}
    local decodeData = CsvReaderUtils.ReadAndParseLocalFile(HERO_CSV_PATH, nil, true)
    for _, data in ipairs(decodeData) do
        self.csvRequireDict[tonumber(data['heroId'])] = data
    end
end

function HeroCsvConfig:GetCsvRequire(heroId, key)
    if self.csvRequireDict == nil then
        self:Init()
    end
    return self.csvRequireDict[heroId][key]
end

--- @return number
function HeroCsvConfig:GetBase(heroId)
    local data = self.heroCsvContentDict:Get(heroId)
    if data == nil then
        data = CsvReaderUtils.ReadLocalFile(self:GetCsvRequire(heroId, 'heroConfig'))
        self.heroCsvContentDict:Add(heroId, data)
    end
    return data
end

--- @return number
function HeroCsvConfig:GetSkill(heroId)
    local data = self.skillCsvContentDict:Get(heroId)
    if data == nil then
        data = Dictionary()
        for _, skillPath in ipairs(self:GetCsvRequire(heroId, 'skillConfigs')) do
            local skillId = tonumber(string.sub(skillPath, -5, -4))
            local content = CsvReaderUtils.ReadLocalFile(skillPath)
            if content ~= nil then
                data:Add(skillId, content)
            end
        end
        self.skillCsvContentDict:Add(heroId, data)
    end
    return data
end

--- @return HeroDataEntry
--- @param heroId number
function HeroCsvConfig:GetHeroDataEntry(heroId)
    local heroCsv = self:GetBase(heroId)
    local skillHero = self:GetSkill(heroId)
    local heroDataEntry = HeroDataEntry()
    heroDataEntry:ParseCsv(heroCsv, heroId)
    for skillHeroId, skillHeroCsv in pairs(skillHero:GetItems()) do
        local heroSkillDataCollection = HeroSkillDataCollection(heroId, skillHeroId)
        heroSkillDataCollection:ParseCsv(skillHeroCsv)
        heroDataEntry:AddSkillData(skillHeroId, heroSkillDataCollection)
    end
    return heroDataEntry
end

return HeroCsvConfig