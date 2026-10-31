require "lua.client.data.Event.EventXmas.EventXmasLoginDataConfig"
require "lua.client.data.Event.EventLunarNewYear.EventLunarEliteSummonConfig"

local LOGIN_PATH = "login_reward.csv"
local DICE_GAME_PATH = "dice_game/dice_game_config.csv"
local DICE_CONFIG_PATH = "dice_game/dice_config.csv"
local DAILY_QUEST_PATH = "daily_quest.csv"

--- @class EventLunarPathConfig
EventLunarPathConfig = Class(EventLunarPathConfig)

function EventLunarPathConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.loginRewardDict = nil

    --- @type EventLunarEliteSummonConfig
    self.eventLunarEliteSummonConfig = EventLunarEliteSummonConfig(path)
end

--- @return Dictionary
function EventLunarPathConfig:GetLoginConfig()
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
        local isReclaim = parsedData[1].is_reclaim
        if isReclaim ~= nil then
            self.isReclaim = MathUtils.ToBoolean(isReclaim)
        end
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
                loginDataConfig = EventXmasLoginDataConfig(listReward, rewardInBound)
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

---@return Dictionary | List
function EventLunarPathConfig:GetDiceConfig()
    local path = string.format("%s/%s", self.path, DICE_GAME_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.diceRewardConfigDict == nil then
        local listReward = List()
        self.diceRewardConfigDict = Dictionary()
        for i = 1, #parsedData do
            local position = tonumber(parsedData[i].position)
            if position ~= nil then
                local rewardInBound = RewardInBound.CreateByParams(parsedData[i])
                if position ~= nil then
                    listReward = List()
                    self.diceRewardConfigDict:Add(position, listReward)
                end
                if rewardInBound.type ~= nil then
                    listReward:Add(rewardInBound)
                end
            end
        end
    end
    return self.diceRewardConfigDict
end

--- @return List
function EventLunarPathConfig:GetRollRequireConfig()
    local path = string.format("%s/%s", self.path, DICE_CONFIG_PATH)
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

--- @type Dictionary -- <number, QuestElementConfig>
function EventLunarPathConfig:GetQuestConfig()
    if self.dailyQuestDict == nil then
        local path = string.format("%s/%s", self.path, DAILY_QUEST_PATH)
        self.dailyQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    end
    return self.dailyQuestDict
end

--- @return Dictionary
function EventLunarPathConfig:IsNewLogin()
    if self.isReclaim == nil then
        return false
    end
    return self.isReclaim
end

--- @return List
function EventLunarPathConfig:GetListExchangeConfig()
    if self.listExchange == nil then
        local path = string.format("%s/%s", self.path, "exchange_reward.csv")
        require "lua.client.data.Event.ExchangeEventConfig"
        self.listExchange = ExchangeEventConfig.GetListExchangeConfigPath(path)
    end
    return self.listExchange
end

--- @return List
function EventLunarPathConfig:GetListExchangeChapBossConfig()
    if self.listExchangeBoss == nil then
        local path = string.format("%s/%s", self.path, "lunar_shop.csv")
        require "lua.client.data.Event.ExchangeEventConfig"
        self.listExchangeBoss = ExchangeEventConfig.GetListExchangeConfigPath(path)
    end
    return self.listExchangeBoss
end

--- @return List
function EventLunarPathConfig:GetListLunarBossConfig()
    if self.listLunarBossConfig == nil then
        local path = string.format("%s/%s", self.path, "guild_boss/boss_config.csv")
        require "lua.client.data.Event.EventLunarNewYear.LunarBossConfig"
        self.listLunarBossConfig = LunarBossConfig.GetListLunarBossConfig(path)
    end
    return self.listLunarBossConfig
end

--- @return LunarBossConfig
function EventLunarPathConfig:GetLunarBossConfigByChapter(chapter)
    return self:GetListLunarBossConfig():Get(chapter)
end

--- @return List
function EventLunarPathConfig:GetStaminaBossConfig()
    if self.staminaBossConfig == nil then
        local path = string.format("%s/%s", self.path, "guild_boss/challenge_config.csv")
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        self.staminaBossConfig = tonumber(parsedData[1].money_value)
    end
    return self.staminaBossConfig
end

--- @return {listGoldenTimeReward : List, lastDuration : number}
function EventLunarPathConfig:GetGoldenTimeConfig()
    if self._goldenTimeConfig == nil then
        local path = string.format("%s/%s", self.path, "idle_reward.csv")
        require "lua.client.data.Event.GoldenTimeConfig"
        self._goldenTimeConfig = GoldenTimeConfig(path)
    end
    return self._goldenTimeConfig
end