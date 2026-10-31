require "lua.client.data.Event.EventTowerOfEitri.EventTowerOfEitriExchangeItemData"

local NORMAL_FLOOR_REWARD_PATH = "building_floor_reward.csv"
local GOLDEN_FLOOR_REWARD_PATH = "golden_floor_reward_bonus.csv"
local TOWER_OPEN_CONFIG_PATH = "tower_open_config.csv"
local EXCHANGE_BONUS_REWARD_PATH = "exchange_bonus_reward.csv"
local EXCHANGE_REWARD_PATH = "exchange_reward.csv"
local TOWER_QUEST_PATH = "tower_building_quest.csv"
local DAILY_QUEST_PATH = "daily_quest.csv"
local SERVER_BUILDING_REWARD = "server_building_reward.csv"

--- @class EventTowerOfEitriConfig
EventTowerOfEitriConfig = Class(EventTowerOfEitriConfig)
function EventTowerOfEitriConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.dictServerBuildingReward = Dictionary()
end

-----------------------------------------MainMenu-----------------------------------------

--- @return Dictionary
function EventTowerOfEitriConfig:GetServerBuildingRewardConfig()
    local listFloor = List()
    local path = string.format("%s/%s", self.path, SERVER_BUILDING_REWARD)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    ---@type List
    local listReward
    for i = 1, #parserData do
        local data = parserData[i]
        local floor = tonumber(data["floor"])
        if floor then
            listFloor:Add(floor)
            listReward = List()
            self.dictServerBuildingReward:Add(floor, listReward)
        end
        ---@type RewardInBound
        local rewardInBound = RewardInBound.CreateBySingleParam(tonumber(data["res_type"]), tonumber(data["res_id"]), tonumber(data["res_number"]), tonumber(data["res_data"]))
        listReward:Add(rewardInBound)
    end
    return self.dictServerBuildingReward, listFloor
end

-----------------------------------------TowerData-----------------------------------------

--- @return List
function EventTowerOfEitriConfig:GetNormalFloorRewardConfig()
    return self:ReadRewardRate(NORMAL_FLOOR_REWARD_PATH)
end

--- @return List
function EventTowerOfEitriConfig:GetGoldenFloorRewardConfig()
    return self:ReadRewardRate(GOLDEN_FLOOR_REWARD_PATH)
end

--- @return List
function EventTowerOfEitriConfig:ReadRewardRate(path)
    local targetList = List()
    local path = string.format("%s/%s", self.path, path)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local totalRate = 0
    for i = 1, #parserData do
        local rate = tonumber(parserData[i].rate)
        if tonumber(parserData[i].rate) < 0 then
            rate = 0
        end
        totalRate = totalRate + rate
    end

    for i = #parserData, 1, -1 do
        local data = parserData[i]
        local rewardInBound = RewardInBound.CreateBySingleParam(tonumber(data["res_type"]), tonumber(data["res_id"]), tonumber(data["res_number"]), tonumber(data["res_data"])):GetIconData()
        local rate = tonumber(data["rate"])
        if rate < 0 then
            rate = totalRate
        end
        rewardInBound.rate = MathUtils.RoundDecimal(rate / totalRate * 100, 1)
        targetList:Add(rewardInBound)
    end
    return targetList
end

--- @return {dailyFree, openMoneyType, openMoneyValue, goldenIntervalFloor}
function EventTowerOfEitriConfig:GetEventTowerConfig()
    local path = string.format("%s/%s", self.path, TOWER_OPEN_CONFIG_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local data = parserData[1]
    local eventDataConfig = {}
    eventDataConfig.dailyFree = tonumber(data["daily_open_free_number"])
    eventDataConfig.openMoneyType = tonumber(data["open_money_type"])
    eventDataConfig.openMoneyValue = tonumber(data["open_money_value"])
    eventDataConfig.goldenIntervalFloor = tonumber(data["golden_interval_floor"])
    return eventDataConfig
end

-----------------------------------------ExchangeData-----------------------------------------

---@return Dictionary <List|EventTowerOfEitriExchangeItemData>
function EventTowerOfEitriConfig:GetExchangeRewardConfig()
    local path = string.format("%s/%s", self.path, EXCHANGE_REWARD_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local dictStageReward = Dictionary()

    ---@type List
    local listReward
    local lastStageId = -1
    for i = 1, #parserData do
        local data = parserData[i]
        local stageId = math.floor(tonumber(data["id"]) / 1000)
        if stageId ~= lastStageId then
            lastStageId = stageId
            listReward = List()
            dictStageReward:Add(lastStageId, listReward)
        end
        if listReward then
            listReward:Add(EventTowerOfEitriExchangeItemData.CreateByParams(data))
        end
    end
    return dictStageReward
end

---@return EventTowerOfEitriExchangeItemData
function EventTowerOfEitriConfig:GetExchangeRewardItemById(id)
    local stageId = math.floor(id / 1000)
    if not self:GetExchangeRewardConfig():IsContainKey(stageId) then
        print("GetExchangeRewardItemById not contain key: ", stageId)
        return
    end
    for _, v in pairs(self:GetExchangeRewardConfig():Get(stageId):GetItems()) do
        if v.id == id then
            return v
        end
    end
end

function EventTowerOfEitriConfig:GetExchangeBonusRewardConfig()
    local dictExchangeBonusReward = Dictionary()
    local path = string.format("%s/%s", self.path, EXCHANGE_BONUS_REWARD_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    for i = 1, #parserData do
        local data = parserData[i]
        local exchangeId = data["exchange_id"]
        ---@type RewardInBound
        local rewardInBound = RewardInBound.CreateBySingleParam(tonumber(data["res_type"]), tonumber(data["res_id"]), tonumber(data["res_number"]), tonumber(data["res_data"]))
        dictExchangeBonusReward:Add(exchangeId, rewardInBound)
    end
    return dictExchangeBonusReward
end

-----------------------------------------QuestData-----------------------------------------

--- @return Dictionary
function EventTowerOfEitriConfig:GetTowerQuestConfig()
    local path = string.format("%s/%s", self.path, TOWER_QUEST_PATH)
    local treasureQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    return treasureQuestDict
end

--- @return Dictionary
function EventTowerOfEitriConfig:GetDailyQuestConfig()
    local path = string.format("%s/%s", self.path, DAILY_QUEST_PATH)
    local dailyQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    return dailyQuestDict
end

return EventTowerOfEitriConfig