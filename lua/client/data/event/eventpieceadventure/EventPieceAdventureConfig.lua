local KEY_ITEM_REWARD = "key_item_reward.csv"
local REGULAR_ITEM_REWARD = "regular_item_reward.csv"
local ADVENTURE_CONFIG = "adventure_config.csv"
local DAILY_QUEST_PATH = "daily_quest/daily_quest_reward.csv"

--- @class EventPieceAdventureConfig
EventPieceAdventureConfig = Class(EventPieceAdventureConfig)
function EventPieceAdventureConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.keyRewardDict = Dictionary()
    --- @type Dictionary
    self.regularRewardDict = Dictionary()
    --- @type Dictionary
    self.regularRewardWithoutNumberDict = Dictionary()
    --- @type Dictionary
    self.groupRewardDict = Dictionary()
end

--- @return List
function EventPieceAdventureConfig:_GetListExchangeConfigPath(key, csv)
    ---@type List
    local list = self[key]
    if list == nil then
        local path = string.format("%s/%s", self.path, csv)
        require "lua.client.data.Event.ExchangeEventConfig"
        list = ExchangeEventConfig.GetListExchangeConfigPath(path)
        self[key] = list
    end
    return list
end

--- @return List
function EventPieceAdventureConfig:GetListExchangeConfig()
    return self:_GetListExchangeConfigPath("listExchange", "exchange_reward.csv")
end

--- @return Dictionary
function EventPieceAdventureConfig:GetDailyQuestConfig()
    local path = string.format("%s/%s", self.path, DAILY_QUEST_PATH)
    local dailyQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    return dailyQuestDict
end

--- @return  table
function EventPieceAdventureConfig:GetAdventureConfig()
    if self.adventureConfig == nil then
        local path = string.format("%s/%s", self.path, ADVENTURE_CONFIG)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Get EventConfig nil %s", path))
            return
        end

        self.adventureConfig = {
            ["size"] = tonumber(parsedData[1].size),
        }
    end
    return self.adventureConfig
end

--- @return  List
function EventPieceAdventureConfig:GetRegularItemRewardDict()
    local path = string.format("%s/%s", self.path, REGULAR_ITEM_REWARD)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end

    for i = 1, #parsedData do
        local id = tonumber(parsedData[i].id);
        if id ~= nil then
            local itemIconData = RewardInBound.CreateByParams(parsedData[i])
            self.regularRewardDict:Add(id, itemIconData)
        end
    end
end

--- @return  List
function EventPieceAdventureConfig:GetRegularItemWithoutNumberRewardDict()
    local path = string.format("%s/%s", self.path, REGULAR_ITEM_REWARD)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end

    for i = 1, #parsedData do
        local id = tonumber(parsedData[i].id);
        if id ~= nil then
            local itemIconData = RewardInBound.CreateBySingleParam(parsedData[i].res_type, parsedData[i].res_id, "")
            self.regularRewardWithoutNumberDict:Add(id, itemIconData)
        end
    end
end

function EventPieceAdventureConfig:GetRegularRewardById(id)
    if self.regularRewardDict:Count() == 0 then
        self:GetRegularItemRewardDict()
    end

    for k,v in pairs(self.regularRewardDict:GetItems()) do
        if k == id then
            return v
        end
    end
    return nil
end

function EventPieceAdventureConfig:GetRegularRewardWithoutNumberById(id)
    if self.regularRewardWithoutNumberDict:Count() == 0 then
        self:GetRegularItemWithoutNumberRewardDict()
    end

    for k,v in pairs(self.regularRewardWithoutNumberDict:GetItems()) do
        if k == id then
            return v
        end
    end
    return nil
end

function EventPieceAdventureConfig:GetKeyItemRewardConfig()
    local path = string.format("%s/%s", self.path, KEY_ITEM_REWARD)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end

    for i = 1, #parsedData do
        local id = tonumber(parsedData[i].id);
        if id ~= nil then
            local itemIconData = RewardInBound.CreateByParams(parsedData[i])
            self.keyRewardDict:Add(id, itemIconData)
        end
    end

    local rewardDictTemp = nil

    for _,v in ipairs(parsedData) do
        if v.floor ~= nil then
            local floorId = tonumber(v.floor)
            ---@type Dictionary
            rewardDictTemp = Dictionary()
            self.groupRewardDict:Add(floorId, rewardDictTemp)
        end

        if v.id ~= nil then
            local id = tonumber(v.id)
            local reward = self:GetReward(id)
            rewardDictTemp:Add(id, reward)
        end
    end
end

--- @return Dictionary
function EventPieceAdventureConfig:GetRewardByFloor(floorId)
    if self.groupRewardDict:Count() == 0 then
        self:GetKeyItemRewardConfig()
    end

    for k,v in pairs(self.groupRewardDict:GetItems()) do
        if k == floorId then
            local listReward = List()
            for _,v1 in pairs(v:GetItems()) do
                listReward:Add(v1)
            end
            return listReward
        end
    end
    return nil
end

--- @return  Dictionary
function EventPieceAdventureConfig:GetKeyRewardDict()
    if self.keyRewardDict:Count() == 0 then
        self:GetKeyItemRewardConfig()
    end

    return self.keyRewardDict
end

--- @return  number
function EventPieceAdventureConfig:GetFloorCount()
    if self.groupRewardDict:Count() == 0 then
        self:GetKeyItemRewardConfig()
    end

    return self.groupRewardDict:Count()
end

function EventPieceAdventureConfig:GetKeyRewardById(id)
    if self.keyRewardDict:Count() == 0 then
        self:GetKeyItemRewardConfig()
    end

    for k,v in pairs(self.keyRewardDict:GetItems()) do
        if k == id then
            return v
        end
    end
    return nil
end


function EventPieceAdventureConfig:GetReward(id)
    local data = self.keyRewardDict:Get(id)
    return data
end

return EventPieceAdventureConfig