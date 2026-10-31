--- @class EventNewHeroTreasureConfig
EventNewHeroTreasureConfig = Class(EventNewHeroTreasureConfig)

function EventNewHeroTreasureConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.dictTreasureReward = nil
end

--- @return TreasureRewardConfig
function EventNewHeroTreasureConfig:ReadCsvTreasure()
    if self.dictTreasureReward == nil then
        require "lua.client.data.Event.EventNewHeroTreasure.TreasureRewardConfig"
        local path = string.format("%s/%s", self.path, "island_reward.csv")
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("GetListTreasureReward nil %s", path))
            return
        end
        self.dictTreasureReward = Dictionary()
        ---@type TreasureRewardConfig
        local treasureRewardConfig = nil
        for i = 1, #parsedData do
            if parsedData[i].id ~= nil then
                treasureRewardConfig = TreasureRewardConfig(parsedData[i])
                ---@type List
                local list = self.dictTreasureReward:Get(treasureRewardConfig.line)
                if list == nil then
                    list = List()
                    self.dictTreasureReward:Add(treasureRewardConfig.line, list)
                end
                list:Add(treasureRewardConfig)
            else
                treasureRewardConfig:AddReward(parsedData[i])
            end
        end
    end
end

--- @return TreasureRewardConfig
function EventNewHeroTreasureConfig:GetTreasureRewardConfig(line, index)
    self:ReadCsvTreasure()
    return self.dictTreasureReward:Get(line):Get(index)
end

--- @return number
function EventNewHeroTreasureConfig:GetTreasureLine()
    self:ReadCsvTreasure()
    return self.dictTreasureReward:Count()
end

--- @return List -- TreasureRewardConfig
function EventNewHeroTreasureConfig:GetListTreasureRewardConfig(line)
    self:ReadCsvTreasure()
    return self.dictTreasureReward:Get(line)
end

--- @return TreasureRewardConfig
function EventNewHeroTreasureConfig:ReadCsvLineComplete()
    if self.dictListRewardLineComplete == nil then
        require "lua.client.data.Event.EventNewHeroTreasure.FinalTreasureRewardConfig"
        local path = string.format("%s/%s", self.path, "line_complete_reward.csv")
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("GetListRewardLineComplete nil %s", path))
            return
        end
        self.dictListRewardLineComplete = Dictionary()
        ---@type FinalTreasureRewardConfig
        local treasureRewardConfig = nil
        for i = 1, #parsedData do
            if parsedData[i].id ~= nil then
                treasureRewardConfig = FinalTreasureRewardConfig(parsedData[i])
                self.dictListRewardLineComplete:Add(treasureRewardConfig.id, treasureRewardConfig)
            else
                treasureRewardConfig:AddReward(parsedData[i])
            end
        end
    end
end

--- @return {moneyType, moneyValue, reward}
function EventNewHeroTreasureConfig:GetRewardBuy()
    if self.rewardBuy == nil then
        local path = string.format("%s/%s", self.path, "reward_buy.csv")
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("GetRewardBuy nil %s", path))
            return
        end
        self.rewardBuy = {}
        self.rewardBuy.moneyType = tonumber(parsedData[1].money_type)
        self.rewardBuy.moneyValue = tonumber(parsedData[1].money_value)
        self.rewardBuy.reward = RewardInBound.CreateByParams(parsedData[1])
    end
    return self.rewardBuy
end

--- @return FinalTreasureRewardConfig
function EventNewHeroTreasureConfig:GetFinalTreasureRewardConfig(index)
    self:ReadCsvLineComplete()
    return self.dictListRewardLineComplete:Get(index)
end

--- @return Dictionary
function EventNewHeroTreasureConfig:GetDictRewardLineComplete()
    self:ReadCsvLineComplete()
    return self.dictListRewardLineComplete
end