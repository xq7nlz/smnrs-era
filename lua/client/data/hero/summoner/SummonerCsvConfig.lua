require "lua.client.data.Hero.Summoner.SummonerCsvDetail"

local SUMMONER_PATH = "csv/client/summoner_config.json"

--- @class SummonerCsvConfig
SummonerCsvConfig = Class(SummonerCsvConfig)

function SummonerCsvConfig:Ctor()
    --- @type Dictionary
    self.csvRequireDict = nil
end

--- @return void
function SummonerCsvConfig:Init()
    local decodeData = CsvReaderUtils.ReadAndParseLocalFile(SUMMONER_PATH, nil, true)

    self.csvRequireDict = Dictionary()
    for _, data in ipairs(decodeData) do
        local detail = SummonerCsvDetail()
        detail:ParseData(data)
        self.csvRequireDict:Add(detail.id, detail)
    end
end

--- @return SummonerCsvDetail
function SummonerCsvConfig:GetSummoner(id)
    if self.csvRequireDict == nil then
        self:Init()
    end
    local data = self.csvRequireDict:Get(id)
    if data == nil then
        XDebug.Error(string.format("summoner is nil: %s", LogUtils.ToDetail(id)))
    end
    return data
end

--- @return string
--- @param summonerId HeroClassType
function SummonerCsvConfig:GetSkillPath(summonerId, skillId, tier)
    local entry = self:GetSummoner(summonerId)
    return entry:GetSkillId(skillId):Get(tier)
end

--- @return List
--- @param summonerId HeroClassType
function SummonerCsvConfig:GetMastery(summonerId, masteryId)
    return self:GetSummoner(summonerId):GetMastery(masteryId)
end

--- @return SummonerDataEntry
--- @param summonerId HeroClassType
function SummonerCsvConfig:GetDataEntry(summonerId)
    local entry = self:GetSummoner(summonerId)

    local summonerDataEntry = SummonerDataEntry()
    local statContent = CsvReaderUtils.ReadLocalFile(entry.statConfigPath)
    summonerDataEntry:ParseCsv(statContent, summonerId)

    --- @param skillData List
    for skillId, skillData in pairs(entry.skillIdDict:GetItems()) do
        local summonerSkillDataCollection = SummonerSkillDataCollection(summonerId, skillId)
        for _, pathByTier in ipairs(skillData:GetItems()) do
            local content = CsvReaderUtils.ReadLocalFile(pathByTier)
            summonerSkillDataCollection:ParseCsv(content)
        end
        summonerDataEntry:AddSkillData(skillId, summonerSkillDataCollection)
    end

    for _, masteryPath in ipairs(entry.masteryList:GetItems()) do
        local summonerMastery = SummonerMastery()
        local contentMaster = CsvReaderUtils.ReadLocalFile(masteryPath)
        summonerMastery:ParseCsv(contentMaster)

        summonerDataEntry:AddMastery(summonerMastery)
    end
    return summonerDataEntry
end

return SummonerCsvConfig