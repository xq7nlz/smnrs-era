require "lua.client.data.Event.GuildQuest.GuildQuestMinDonate"

local CSV_PATH = "csv/event/event_guild_quest/data_%s/min_donation.csv"

--- @class GuildQuestMinDonateConfig
GuildQuestMinDonateConfig = Class(GuildQuestMinDonateConfig)

--- @return void
function GuildQuestMinDonateConfig:Ctor()
    ---@type Dictionary
    self.dictData = Dictionary()
end

--- @return GuildQuestMinDonate
function GuildQuestMinDonateConfig:GetDataFromCsv(csvPath)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(csvPath)
    ---@type GuildQuestMinDonate
    local data = GuildQuestMinDonate()
    for i = 1, #parsedData do
        data:ParsedData(parsedData[i])
    end
    return data
end

--- @return GuildQuestMinDonate
function GuildQuestMinDonateConfig:GetDataFromId(id)
    local data = self.dictData:Get(id)
    if data == nil then
        data = self:GetDataFromCsv(string.format(CSV_PATH, id))
        self.dictData:Add(id, data)
    end
    return data
end

return GuildQuestMinDonateConfig