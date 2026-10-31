require "lua.client.data.event.EventServerOpen.ServerOpenMarket"
require "lua.client.data.Event.EventServerOpen.ServerOpenProgress"

--- @class EventServerOpenConfig
EventServerOpenConfig = Class(EventServerOpenConfig)
local CSV_MARKET_PATH = "csv/server_open/market.csv"
local CSV_QUEST_PATH = "csv/server_open/quest.csv"
local CSV_PROGRESS_PATH = "csv/server_open/progress.csv"

function EventServerOpenConfig:Ctor()
    ---@type List
    self.listDay = nil
    ---@type Dictionary --<id, day>
    self.dictQuestDay = Dictionary()

    ---@type Dictionary --<id, QuestElementConfig>
    self.dictQuestById = nil
    ---@type Dictionary --<id, day>
    self.dictMarketDay = Dictionary()
    ---@type Dictionary --<id, ServerOpenMarket>
    self.dictMarketById = nil

    ---@type List --<ServerOpenProgress>
    self.listProgress = nil
    self:ReadMarket()
    self:ReadProgress()
    self:ReadQuest()
end

function EventServerOpenConfig:ReadMarket()
    if (self.dictMarketById == nil) then
        self.dictMarketById = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CSV_MARKET_PATH)
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
end

--- @type Dictionary
function EventServerOpenConfig:ReadProgress()
    if (self.listProgress == nil) then
        self.listProgress = List()

        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CSV_PROGRESS_PATH)
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
end

--- @return void
function EventServerOpenConfig:_AddDay(day)
    if self.listDay == nil then
        self.listDay = List()
    end
    if self.listDay:IsContainValue(day) == false then
        self.listDay:Add(day)
    end
end

--- @return void
function EventServerOpenConfig:ReadQuest()
    if (self.dictQuestById == nil) then
        self.dictQuestById = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CSV_QUEST_PATH)
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
end

--- @return void
function EventServerOpenConfig:GetIndexDayLock() -- tra ve ngay hien tai + 1
    local indexDayLock = nil
    --- @type ServerOpenInBound
    local eventOpenServerInbound = zg.playerData:GetMethod(PlayerDataMethod.SERVER_OPEN)
    local timeNextDay = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime() + TimeUtils.SecondADay)
    local timeStartDay = TimeUtils.GetTimeStartDayFromSec(eventOpenServerInbound.startTime)
    local time = timeNextDay - timeStartDay
    indexDayLock = math.floor(time / TimeUtils.SecondADay) + 1
    --XDebug.Log("START TIME " .. tostring(eventOpenServerInbound.startTime) .. " indexDayLock " .. tostring(indexDayLock))
    return indexDayLock
end

return EventServerOpenConfig
