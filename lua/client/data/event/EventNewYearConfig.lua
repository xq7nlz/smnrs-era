local CARD_PATH = "event_card.csv"
local LOTTERY_CONFIG_PATH = "lottery/lottery_config.csv"
local LOTTERY_TICKET_CONFIG_PATH = "lottery/ticket_config.csv"

--- @class EventNewYearConfig
EventNewYearConfig = Class(EventNewYearConfig)

function EventNewYearConfig:Ctor(path)
    self.path = path
end

function EventNewYearConfig:GetGemPackListConfig()
    if self.gemPackList == nil then
        local path = string.format("%s/%s", self.path, "gem_box.csv")
        require "lua.client.data.Event.ExchangeEventConfig"
        self.gemPackList = ExchangeEventConfig.GetListExchangeConfigPath(path)
    end
    return self.gemPackList
end

function EventNewYearConfig:GetCardDurationMaxDictionaryConfig()
    if self.cardDuration == nil then
        local path = string.format("%s/%s", self.path, CARD_PATH)
        self.cardDuration= Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        for i = 1, #parsedData do
            if parsedData[i].id ~= nil then
                local duration = parsedData[i].duration_in_days
                self.cardDuration:Add(i, duration)
            end
        end
        return self.cardDuration
    end
    return self.cardDuration
end

--- @return List
function EventNewYearConfig:GetRollRequireConfig()
    local path = string.format("%s/%s", self.path, LOTTERY_TICKET_CONFIG_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.requireList == nil then
        self.requireList = List()
        for i = 1, #parsedData do
            self.requireList:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, parsedData[i].money_type, parsedData[i].money_value))
        end
    end
    return self.requireList
end

---@return Dictionary
function EventNewYearConfig:GetLotteryData()
    local path = string.format("%s/%s", self.path, LOTTERY_CONFIG_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.diceRewardInboundDict == nil then
        local listReward = nil
        self.diceRewardInboundDict = Dictionary()
        for i = 1, #parsedData do
            local id = parsedData[i].id
            if id == nil then
                listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
            else
                id = tonumber(id)
                listReward = List()
                listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
                self.diceRewardInboundDict:Add(id, listReward)
            end
        end
    end
    return self.diceRewardInboundDict
end

--- @return GoldenTimeConfig
function EventNewYearConfig:GetGoldenTimeConfig()
    if self._goldenTimeConfig == nil then
        local path = string.format("%s/%s", self.path, "idle_reward.csv")
        require "lua.client.data.Event.GoldenTimeConfig"
        self._goldenTimeConfig = GoldenTimeConfig(path)
    end
    return self._goldenTimeConfig
end