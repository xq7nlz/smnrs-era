require "lua.client.data.Event.EventThanksGiving.EventThanksGivingLoginDataConfig"
local LOGIN_PATH = "login_reward.csv"
local DAILY_QUEST_PATH = "daily_quest.csv"
local BINGO_REWARD_CONFIG_PATH = "bingo/bingo_reward.csv"
local BINGO_REWARD_RATE_CONFIG = "bingo/bingo_reward_rate.csv"
local BINGO_CONFIG_PATH = "bingo/bingo_config.csv"
local BINGO_QUEST_CONFIG_PATH = "bingo/bingo_quest.csv"

--- @class EventMayDayConfig
EventMayDayConfig = Class(EventMayDayConfig)

function EventMayDayConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.loginRewardDict = nil

    --- @type Dictionary
    self.diceRewardInboundDict = nil
    --- @type Dictionary
    self.diceRewardExtraInboundDict = nil
    --- @type Dictionary
    self.lapRewardInboundDict = nil
    --- @type List
    self.requireList = nil
    --- @type List
    self.rewardList = nil
end

--- @return List
function EventMayDayConfig:GetListBingoQuestConfig()
    if self._listQuestConfig == nil then
        local path = string.format("%s/%s", self.path, BINGO_QUEST_CONFIG_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Get EventConfig nil %s", path))
            return
        end
        self._listQuestConfig = List()
        --- @type QuestElementConfig
        local questConfig
        for i = 1, #parsedData do
            local questId = parsedData[i].quest_id
            if questId ~= nil then
                questConfig = QuestElementConfig.GetInstanceFromCsv(parsedData[i])
                self._listQuestConfig:Add(questConfig)
            else
                questConfig:AddResData(RewardInBound.CreateByParams(parsedData[i]))
            end
        end
    end
    return self._listQuestConfig
end

function EventMayDayConfig:GetBingoConfig()
    local path = string.format("%s/%s", self.path, BINGO_CONFIG_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end

    local data = parsedData[1]
    local eventDataConfig = {}
    eventDataConfig.size = data.size
    eventDataConfig.max_open_slot = tonumber(data.max_open_slot)
    return eventDataConfig
end

---@return Dictionary
function EventMayDayConfig:GetBingoData()
    local path = string.format("%s/%s", self.path, BINGO_REWARD_RATE_CONFIG)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.diceRewardInboundDict == nil then
        self.diceRewardInboundDict = Dictionary()
        for i = 1, #parsedData do
            local id = parsedData[i].id
            if id ~= nil then
                id = tonumber(id)
                local itemIconData = RewardInBound.CreateByParams(parsedData[i])
                self.diceRewardInboundDict:Add(id, itemIconData)
            end
        end
    end
    return self.diceRewardInboundDict
end

function EventMayDayConfig:GetListRewardRate()
    if self.listRewardRate == nil then
        self.listRewardRate = List()
        local path = string.format("%s/%s", self.path, BINGO_REWARD_RATE_CONFIG)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Get EventConfig nil %s", path))
            return
        end

        local totalRate = 0
        for i = 1, #parsedData do
            totalRate = totalRate + tonumber(parsedData[i].rate)
        end
        for i = 1, #parsedData do
            --- @type RewardInBound
            local rewardInBound = RewardInBound.CreateByParams(parsedData[i]):GetIconData()
            rewardInBound.rate = MathUtils.RoundDecimal(tonumber(parsedData[i].rate) / totalRate * 100,2)
            self.listRewardRate:Add(rewardInBound)
        end
    end
    return self.listRewardRate
end

---@return Dictionary
function EventMayDayConfig:GetBingoRewardExtraData()
    local path = string.format("%s/%s", self.path, BINGO_REWARD_CONFIG_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.diceRewardExtraInboundDict == nil then
        self.diceRewardExtraInboundDict = Dictionary()
        for i = 1, #parsedData do
            local id = parsedData[i].total_bingo
            if id ~= nil then
                id = tonumber(id)
                local itemIconData = RewardInBound.CreateByParams(parsedData[i])
                self.diceRewardExtraInboundDict:Add(id, itemIconData)
            end
        end
    end
    return self.diceRewardExtraInboundDict
end

function EventMayDayConfig:GetRewardById(id)
    for k,v in pairs(self:GetBingoData():GetItems()) do
        if k == id then
            return v
        end
    end
    return nil
end

function EventMayDayConfig:GetRewardExtraById(id)
    for k,v in pairs(self:GetBingoRewardExtraData():GetItems()) do
        if k == id then
            return v
        end
    end
    return nil
end

--- @return Dictionary
function EventMayDayConfig:GetLoginConfig()
    local path = string.format("%s/%s", self.path, LOGIN_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.loginRewardDict == nil then
        local listReward = nil
        -- Dictionary(page, Dictionary(day, List<RewardInBound>)
        self.pageDict = Dictionary()
        self.loginRewardDict = Dictionary()
        local page = 1
        local loginDataConfig = nil
        for i = 1, #parsedData do
            local day = parsedData[i].day
            if day == nil then
                loginDataConfig.rewardList:Add(RewardInBound.CreateByParams(parsedData[i]))
            else
                day = tonumber(parsedData[i].day)
                listReward = List()
                listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
                local rewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, parsedData[i].money_type, parsedData[i].money_value)
                loginDataConfig = EventHalloweenLoginDataConfig(listReward, rewardInBound)
                self.loginRewardDict:Add(day, loginDataConfig)
                if day % 7 == 0 then
                    self.pageDict:Add(page, self.loginRewardDict)
                    page = page + 1
                    self.loginRewardDict = Dictionary()
                end
            end
        end
    end
    return self.pageDict
end

---@return Dictionary
function EventMayDayConfig:GetQuestId(lapCompleted)
    ---@param v EventHalloweenLapDataConfig
    for i, v in pairs(self.lapRewardInboundDict:GetItems()) do
        if lapCompleted < v:GetLapRequire() then
            return i - 1
        end
    end
    return self.lapRewardInboundDict:Count()
end

--- @return List
function EventMayDayConfig:GetListExchangeConfig()
    if self.listExchange == nil then
        local path = string.format("%s/%s", self.path, "exchange_reward.csv")
        require "lua.client.data.Event.ExchangeEventConfig"
        self.listExchange = ExchangeEventConfig.GetListExchangeConfigPath(path)
    end
    return self.listExchange
end

--- @return {listGoldenTimeReward : List, lastDuration : number}
function EventMayDayConfig:GetGoldenTimeConfig()
    if self._goldenTimeConfig == nil then
        local path = string.format("%s/%s", self.path, "idle_reward.csv")
        require "lua.client.data.Event.GoldenTimeConfig"
        self._goldenTimeConfig = GoldenTimeConfig(path)
    end
    return self._goldenTimeConfig
end

--- @return Dictionary
function EventMayDayConfig:GetDailyQuestConfig()
    local path = string.format("%s/%s", self.path, DAILY_QUEST_PATH)
    local dailyQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    return dailyQuestDict
end