require "lua.client.data.Event.GuildQuest.QuestRewardActivity"

local CSV_PATH = "csv/event/event_guild_quest/data_%s/reward_activity.csv"

--- @class GuildQuestRewardActivityConfig
GuildQuestRewardActivityConfig = Class(GuildQuestRewardActivityConfig)

--- @return void
function GuildQuestRewardActivityConfig:Ctor()
    ---@type Dictionary --<List<QuestRewardActivity>>
    self.dictExchange = Dictionary()
end

--- @return List
function GuildQuestRewardActivityConfig:GetDataFromCsv(csvPath)
    local list = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(csvPath)
    ---@type QuestRewardActivity
    local data
    for i = 1, #parsedData do
        if parsedData[i].convert_rate ~= nil then
            data = QuestRewardActivity()
            data:ParsedData(parsedData[i])
            list:Add(data)
        elseif data ~= nil then
            data.questElementConfig._listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
        end
    end
    return list
end

--- @return List
function GuildQuestRewardActivityConfig:GetDataFromId(id)
    local listExchangeData = self.dictExchange:Get(id)
    if listExchangeData == nil then
        listExchangeData = self:GetDataFromCsv(string.format(CSV_PATH, id))
        self.dictExchange:Add(id, listExchangeData)
    end
    return listExchangeData
end

return GuildQuestRewardActivityConfig