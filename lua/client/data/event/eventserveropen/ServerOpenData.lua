require "lua.client.data.Event.EventServerOpen.ServerOpenMarket"
require "lua.client.data.Event.EventServerOpen.ServerOpenProgress"

local CSV_MARKET_PATH = "csv/event/event_server_open/data_%s/market.csv"
local CSV_QUEST_PATH = "csv/event/event_server_open/data_%s/quest.csv"
local CSV_PROGRESS_PATH = "csv/event/event_server_open/data_%s/progress.csv"

--- @class ServerOpenData
ServerOpenData = Class(ServerOpenData)

--- @return void
--- @param dataId number
function ServerOpenData:Ctor(dataId)
    self.dataId = dataId
    ---@type List
    self.listDay = List()
    ---@type Dictionary --<id, day>
    self.dictQuestDay = Dictionary()
    ---@type Dictionary --<id, day>
    self.dictMarketDay = Dictionary()
    ---@type List --<ServerOpenProgress>
    self.listProgress = List()
    ---@type Dictionary --<id, QuestElementConfig>
    self.dictQuestById = Dictionary()
    ---@type Dictionary --<id, ServerOpenMarket>
    self.dictMarketById = Dictionary()

    self:ReadCsvMarket(string.format(CSV_MARKET_PATH, self.dataId))
    self:ReadCsvQuest(string.format(CSV_QUEST_PATH, self.dataId))
    self:ReadCsvProgress(string.format(CSV_PROGRESS_PATH, self.dataId))
end

--- @return void
function ServerOpenData:GetIndexDayLock()
    local indexDayLock = nil
    --- @type ServerOpenInBound
    local eventOpenServerInbound = zg.playerData:GetMethod(PlayerDataMethod.SERVER_OPEN)
    local time = zg.timeMgr:GetServerTime() - eventOpenServerInbound:GetTime().startTime
    for i, v in ipairs(self.listDay:GetItems()) do
        if time < (v - 1) * 86400 then
            indexDayLock = i
            break
        end
    end
    return indexDayLock
end

--- @return void
function ServerOpenData:_AddDay(day)
    if self.listDay:IsContainValue(day) == false then
        self.listDay:Add(day)
    end
end

--- @return void
function ServerOpenData:ReadCsvQuest(csvPath)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(csvPath)
    local day = nil
    ---@type QuestElementConfig
    local item = nil
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.day ~= nil then
            day = tonumber(data.day)
            self:_AddDay(day)
        end

        if data.quest_id ~= nil then
            item = QuestElementConfig.GetInstanceFromCsv(data)
            item.id = tonumber(data.quest_id)
            self.dictQuestDay:Add(item.id, day)
            self.dictQuestById:Add(item.id, item)
        else
            item._listReward:Add(RewardInBound.CreateByParams(data))
        end
    end
end

--- @return void
function ServerOpenData:ReadCsvMarket(csvPath)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(csvPath)
    local day = nil
    ---@type ServerOpenMarket
    local item = nil
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.day ~= nil then
            day = tonumber(data.day)
            self:_AddDay(day)
        end
        if data.id ~= nil then
            item = ServerOpenMarket()
            item:ParsedData(data)
            self.dictMarketDay:Add(item.id, day)
            self.dictMarketById:Add(item.id, item)
        else
            item:AddData(data)
        end
    end
end

--- @return void
function ServerOpenData:ReadCsvProgress(csvPath)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(csvPath)
    ---@type ServerOpenProgress
    local item = nil
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id ~= nil then
            item = ServerOpenProgress()
            item:ParsedData(data)
            self.listProgress:Add(item)
        else
            item:AddData(data)
        end
    end
end