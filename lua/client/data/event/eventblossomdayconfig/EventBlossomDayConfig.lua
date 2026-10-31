require "lua.client.data.Event.EventThanksGiving.EventThanksGivingLoginDataConfig"
local LOGIN_PATH = "login_reward.csv"
local DAILY_QUEST_PATH = "daily_quest.csv"
local WISH_REWARD_CONFIG_PATH = "wish/wish_reward_config.csv"
local WISH_CONFIG_PATH = "wish/wish_config.csv"
local WISH_QUEST_CONFIG_PATH = "wish/wish_quest.csv"

--- @class EventBlossomDayConfig
EventBlossomDayConfig = Class(EventBlossomDayConfig)

function EventBlossomDayConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.loginRewardDict = nil

    --- @type Dictionary
    self.diceRewardInboundDict = nil
    --- @type Dictionary
    self.lapRewardInboundDict = nil
    --- @type List
    self.requireList = nil
    --- @type List
    self.rewardList = nil
end

--- @return List
function EventBlossomDayConfig:GetListWishQuestConfig()
    if self._listQuestConfig == nil then
        local path = string.format("%s/%s", self.path, WISH_QUEST_CONFIG_PATH)
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

function EventBlossomDayConfig:GetWishConfig()
    local path = string.format("%s/%s", self.path, WISH_CONFIG_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end

    local data = parsedData[1]
    local eventDataConfig = {}
    eventDataConfig.require = RewardInBound.CreateBySingleParam(ResourceType.Money, data.money_type, data.money_value)
    eventDataConfig.resetConfig = data.reset_config
    return eventDataConfig
end

---@return Dictionary
function EventBlossomDayConfig:GetLuckyWishData()
    local path = string.format("%s/%s", self.path, WISH_REWARD_CONFIG_PATH)
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

--- @return Dictionary
function EventBlossomDayConfig:GetLoginConfig()
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
function EventBlossomDayConfig:GetQuestId(lapCompleted)
    ---@param v EventHalloweenLapDataConfig
    for i, v in pairs(self.lapRewardInboundDict:GetItems()) do
        if lapCompleted < v:GetLapRequire() then
            return i - 1
        end
    end
    return self.lapRewardInboundDict:Count()
end

--- @return List
function EventBlossomDayConfig:GetListExchangeConfig()
    if self.listExchange == nil then
        local path = string.format("%s/%s", self.path, "exchange_reward.csv")
        require "lua.client.data.Event.ExchangeEventConfig"
        self.listExchange = ExchangeEventConfig.GetListExchangeConfigPath(path)
    end
    return self.listExchange
end

--- @return {listGoldenTimeReward : List, lastDuration : number}
function EventBlossomDayConfig:GetGoldenTimeConfig()
    if self._goldenTimeConfig == nil then
        local path = string.format("%s/%s", self.path, "idle_reward.csv")
        require "lua.client.data.Event.GoldenTimeConfig"
        self._goldenTimeConfig = GoldenTimeConfig(path)
    end
    return self._goldenTimeConfig
end

--- @return Dictionary
function EventBlossomDayConfig:GetDailyQuestConfig()
    local path = string.format("%s/%s", self.path, DAILY_QUEST_PATH)
    local dailyQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    return dailyQuestDict
end