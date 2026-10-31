require "lua.client.data.Event.EventHalloween.EventHalloweenLoginDataConfig"
require "lua.client.data.Event.EventHalloween.EventHalloweenLapDataConfig"
local LAP_PATH = "dice_game/lap_quest.csv"
local DICE_GAME_PATH = "dice_game/dice_game_config.csv"
local REQUIRE_PATH = "dice_game/dice_config.csv"
local LOGIN_PATH = "login_reward.csv"
local DAILY_QUEST_PATH = "daily_quest.csv"

--- @class EventHalloweenConfig
EventHalloweenConfig = Class(EventHalloweenConfig)

function EventHalloweenConfig:Ctor(path)
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

--- @return Dictionary
function EventHalloweenConfig:GetLoginConfig()
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
function EventHalloweenConfig:GetDiceConfig()
    local path = string.format("%s/%s", self.path, DICE_GAME_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.diceRewardInboundDict == nil then
        local listReward = nil
        self.diceRewardInboundDict = Dictionary()
        for i = 1, #parsedData do
            local day = parsedData[i].position
            if day == nil then
                listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
            else
                --day = tonumber(parsedData[i].day)
                day = tonumber(day) + 1
                listReward = List()
                listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
                self.diceRewardInboundDict:Add(day, listReward)
            end
        end
    end
    return self.diceRewardInboundDict
end

---@return Dictionary
function EventHalloweenConfig:GetLapConfig()
    local path = string.format("%s/%s", self.path, LAP_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.lapRewardInboundDict == nil then
        ---@type EventHalloweenLapDataConfig
        local lapConfig =  nil
        self.lapRewardInboundDict = Dictionary()
        for i = 1, #parsedData do
            local questId = parsedData[i].quest_id
            if questId == nil then
                lapConfig.rewardList:Add(RewardInBound.CreateByParams(parsedData[i]))
            else
                questId = tonumber(questId)

                local listReward = List()

                listReward:Add(RewardInBound.CreateByParams(parsedData[i]))

                local lapRequire = tonumber(parsedData[i].requirement_1)
                local lapConfig = EventHalloweenLapDataConfig(lapRequire, listReward)
                self.lapRewardInboundDict:Add(questId, lapConfig)
            end
        end
    end
    return self.lapRewardInboundDict
end

---@return Dictionary
function EventHalloweenConfig:GetQuestId(lapCompleted)
    ---@param v EventHalloweenLapDataConfig
    for i, v in pairs(self.lapRewardInboundDict:GetItems()) do
        if lapCompleted < v:GetLapRequire() then
            return i - 1
        end
    end
    return self.lapRewardInboundDict:Count()
end

function EventHalloweenConfig:GetRollRequireConfig()
    local path = string.format("%s/%s", self.path, REQUIRE_PATH)
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

function EventHalloweenConfig:GetRollRewardConfig()
    local path = string.format("%s/%s", self.path, REQUIRE_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.rewardList == nil then
        self.rewardList = List()
        for i = 1, #parsedData do
            self.rewardList:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, parsedData[i].reward_money_type, parsedData[i].reward_money_value))
        end
    end
    return self.rewardList
end

--- @return List
function EventHalloweenConfig:GetListExchangeConfig()
    if self.listExchange == nil then
        local path = string.format("%s/%s", self.path, "exchange_reward.csv")
        require "lua.client.data.Event.ExchangeEventConfig"
        self.listExchange = ExchangeEventConfig.GetListExchangeConfigPath(path)
    end
    return self.listExchange
end

--- @return {listGoldenTimeReward : List, lastDuration : number}
function EventHalloweenConfig:GetGoldenTimeConfig()
    if self._goldenTimeConfig == nil then
        local path = string.format("%s/%s", self.path, "idle_reward.csv")
        require "lua.client.data.Event.GoldenTimeConfig"
        self._goldenTimeConfig = GoldenTimeConfig(path)
    end
    return self._goldenTimeConfig
end

--- @return Dictionary
function EventHalloweenConfig:GetDailyQuestConfig()
    local path = string.format("%s/%s", self.path, DAILY_QUEST_PATH)
    local dailyQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    return dailyQuestDict
end