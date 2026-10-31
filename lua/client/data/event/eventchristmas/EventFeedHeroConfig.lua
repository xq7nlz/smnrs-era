--- @class EventFeedHeroConfig
EventFeedHeroConfig = Class(EventFeedHeroConfig)

function EventFeedHeroConfig:Ctor(path)
    self.path = path .. "/feed_hero"
    --- @type RewardInBound
    self.feedRewardInBound = nil
    --- @type List
    self._listQuestConfig = nil
    --- @type List
    self._listRandomReward = nil
    --- @type List
    self._listInstanceReward = nil

    self:ReadFeedTheBeastConfig()
end

function EventFeedHeroConfig:ReadFeedTheBeastConfig()
    local path = string.format("%s/%s", self.path, "feed_hero_config.csv")
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    self.feedRewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money,
            tonumber(parsedData[1].money_type),
            math.floor(100 / tonumber(parsedData[1].money_value)))
    self.number = tonumber(parsedData[1].number)
    self.amount = tonumber(parsedData[1].amount)

    self._listInstanceReward = List()
    for i = 1, #parsedData do
        self._listInstanceReward:Add(RewardInBound.CreateByParams(parsedData[i]))
    end
end

--- @return List
function EventFeedHeroConfig:GetListQuestConfig()
    if self._listQuestConfig == nil then
        local path = string.format("%s/%s", self.path, "feed_quest.csv")
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

--- @return List
function EventFeedHeroConfig:GetListRandomReward()
    if self._listRandomReward == nil then
        local path = string.format("%s/%s", self.path, "reward_rate.csv")
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Get EventConfig nil %s", path))
            return
        end
        self._listRandomReward = List()
        for i = 1, #parsedData do
            self._listRandomReward:Add(RewardInBound.CreateByParams(parsedData[i]))
        end
    end
    return self._listRandomReward
end

--- @return List
function EventFeedHeroConfig:GetListInstanceReward()
    return self._listInstanceReward
end