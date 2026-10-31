local SKILL_PASSIVE_SUMMONER_CONFIG_PATH = "csv/hero/passive_skill_names_summoner.csv"


--- @class SummonerSkillPassiveConfig
SummonerSkillPassiveConfig = Class(SummonerSkillPassiveConfig)

function SummonerSkillPassiveConfig:Ctor()
    self.heroDict = nil
    self:Init()
end

--- @return Dictionary<summonerId, Dictionary<skill, List<tier>>
function SummonerSkillPassiveConfig:Init()
    self.heroDict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(SKILL_PASSIVE_SUMMONER_CONFIG_PATH)
    for i = 1, #parsedData do
        local data = parsedData[i]['hero_id']:Split('_')
        local summonerId = tonumber(data[1])
        local skillId = tonumber(data[2])
        local tier = tonumber(data[3])

        local skillDict = self.heroDict:Get(summonerId)
        if skillDict == nil then
            skillDict = Dictionary()
            self.heroDict:Add(summonerId, skillDict)
        end

        local tierList = skillDict:Get(skillId)
        if tierList then
            tierList = List()
            skillDict:Add(skillId, tierList)
        end
        tierList:Add(tier)
    end
end

function SummonerSkillPassiveConfig:Get(heroId)
    local data = self.heroDict:Get(heroId)
    if data == nil then
        XDebug.Error(string.format("heroId is nil: %s", tostring(heroId)))
    end
    return data
end

return SummonerSkillPassiveConfig