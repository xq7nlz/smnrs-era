require "lua.client.data.Event.GuildQuest.GuildQuestExchangeData"

local CSV_PATH = "csv/event/event_guild_quest/data_%s/price_reward_exchange.csv"

--- @class GuildQuestExchangeConfig
GuildQuestExchangeConfig = Class(GuildQuestExchangeConfig)

--- @return void
function GuildQuestExchangeConfig:Ctor()
    ---@type Dictionary --<List<GuildQuestExchangeData>>
    self.dictExchange = Dictionary()
end

--- @return List
function GuildQuestExchangeConfig:GetDataFromCsv(csvPath)
    local list = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(csvPath)
    ---@type GuildQuestExchangeData
    local exchangeData
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id ~= nil then
            exchangeData = GuildQuestExchangeData()
            exchangeData:ParsedData(data)
            list:Add(exchangeData)
        else
            exchangeData:AddData(data)
        end
    end
    return list
end

--- @return List
function GuildQuestExchangeConfig:GetDataFromId(id)
    local listExchangeData = self.dictExchange:Get(id)
    if listExchangeData == nil then
        listExchangeData = self:GetDataFromCsv(string.format(CSV_PATH, id))
        self.dictExchange:Add(id, listExchangeData)
    end
    return listExchangeData
end

return GuildQuestExchangeConfig