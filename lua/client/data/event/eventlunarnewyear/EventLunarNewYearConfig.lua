require "lua.client.data.Event.EventXmas.EventXmasLoginDataConfig"
require "lua.client.data.Purchase.LevelPass.GrowthPackLineConfig"
local LOGIN_PATH = "login_reward.csv"
local SPRING_BOX = "spring_box_exchange_reward.csv"
local GROWTH_PACK_BASIC = "/tiger_path/tiger_path_free_reward.csv"
local GROWTH_PACK_PREMIUM = "/tiger_path/hero_premium_line/%s_premium_line.csv"
local HERO_CUSTOMIZE_LINE = "/tiger_path/hero_premium_line/hero_customize_line.csv"
local BONUS_DAILY_QUEST_REWARD_PATH = "csv/event/event_lunar_new_year_2022/data_%s/daily_quest_bonus_reward.csv"
--- @class EventLunarNewYearConfig
EventLunarNewYearConfig = Class(EventLunarNewYearConfig)

function EventLunarNewYearConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.loginRewardDict = nil
    --- @type Dictionary
    self.lineConfig = Dictionary()
    --- @type List
    self.rewardPool = List(0)
    ---@type EventLionDanceConfig
    self._lionDanceConfig = nil
    --- @type Dictionary
    self._bonusDailyQuestRewardDict = Dictionary()
    if path then
        self:GetHeroSelection()
        self:GetEventLionDanceConfig()
    end
end

--- @return Dictionary
function EventLunarNewYearConfig:GetLoginConfig()
    local path = string.format("%s/%s", self.path, LOGIN_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.loginRewardDict == nil then
        local listReward = nil
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

--- @return GrowthPackLineConfig
--- @param dataId number
function EventLunarNewYearConfig:GetTigerPathConfig(dataId, heroId)
    self:_InitLineConfig(dataId, heroId)
    return self.lineConfig:Get(dataId)
end

--- @param dataId number
function EventLunarNewYearConfig:_InitLineConfig(dataId, heroId)
    local growthPackLineConfig = nil
    if heroId ~= nil then
        growthPackLineConfig = GrowthPackLineConfig(dataId, self.path .. GROWTH_PACK_BASIC,
                string.format(self.path .. GROWTH_PACK_PREMIUM, heroId), "number")
    else
        growthPackLineConfig = GrowthPackLineConfig(dataId, self.path .. GROWTH_PACK_BASIC,
                nil, "number")
    end

    if self.lineConfig:IsContainKey(dataId) then
        self.lineConfig:RemoveByKey(dataId)
    end
    self.lineConfig:Add(dataId, growthPackLineConfig)
end

function EventLunarNewYearConfig:GetHeroSelection()
    local path = self.path .. HERO_CUSTOMIZE_LINE
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.number_selection ~= nil then
            self.numberSelect = tonumber(data.number_selection)
        end
        if data.selection_res_type ~= nil then
            ---@type RewardInBound
            local reward = RewardInBound.CreateBySingleParam(data.selection_res_type, data.selection_res_id,
                    data.selection_res_number,
                    data.selection_res_data)
            reward.indexId = tonumber(data.selection_id)
            self.rewardPool:Add(reward)
        end
        self.isLimited = self.stock ~= -1
    end
end

--- @return EventFeedBeastConfig
function EventLunarNewYearConfig:GetEventLionDanceConfig()
    if self._lionDanceConfig == nil then
        require "lua.client.data.Event.EventLunarNewYear.EventLionDanceConfig"
        self._lionDanceConfig = EventLionDanceConfig(self.path)
    end
    return self._lionDanceConfig
end

--- @return Dictionary
function EventLunarNewYearConfig:IsNewLogin()
    if self.isReclaim == nil then
        return false
    end
    return self.isReclaim
end

---@return Dictionary
function EventLunarNewYearConfig:GetListBoxReward()
    local listBoxReward = Dictionary()
    local path = string.format("%s/%s", self.path, SPRING_BOX)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end

    local boxId;
    for i = 1, #parsedData do
        if parsedData[i].id ~= nil then
            local boxReward = {}
            local listReward = List()
            --- Get id of gift box
            boxId = tonumber(parsedData[i].id)
            listBoxReward:Add(boxId, boxReward)
            local currentBoxReward = listBoxReward:Get(boxId)

            --- Add reward definitely not random
            local resType = tonumber(parsedData[i].res_type)
            local resId = tonumber(parsedData[i].res_id)
            local resNumber = tonumber(parsedData[i].res_number)
            currentBoxReward.rewardList = listReward
            currentBoxReward.rewardList:Add({ ["type"] = resType, ["id"] = resId, ["number"] = resNumber })

            --- The information and price of gift box
            ---@type MoneyType
            currentBoxReward.moneyType = tonumber(parsedData[i].money_type)
            currentBoxReward.moneyValue = tonumber(parsedData[i].money_value)
            currentBoxReward.limit = tonumber(parsedData[i].limit)
            currentBoxReward.id = boxId
        end
        --- Add reward random
        listBoxReward:Get(boxId).rewardList:Add(self:GetReward(parsedData[i]))
    end
    return listBoxReward;
end

--- @return {type, id, data, number}
--- @param data {random_res_type, random_res_id, random_res_data, random_res_number}
--- format data to normal reward data
function EventLunarNewYearConfig:GetReward(data)
    local reward = {}
    if data ~= nil then
        reward.type = tonumber(data.random_res_type)
        reward.id = tonumber(data.random_res_id)
        reward.data = data.random_res_data
        reward.number = tonumber(data.random_res_number)
    end
    return reward
end

function EventLunarNewYearConfig:_ReadBonusQuestRewardData(dataId)
    local rewardDict = Dictionary()
    local dataConfig = CsvReaderUtils.ReadAndParseLocalFile(string.format(BONUS_DAILY_QUEST_REWARD_PATH, dataId))
    local listReward = List()
    local eventItemDictConfig = ClientConfigUtils.GetEventItemConfig()
    local checkCondition = function(i)
        --- @type RewardInBound
        local reward = RewardInBound.CreateByParams(dataConfig[i])
        local itemId = reward.id
        if eventItemDictConfig:IsContainKey(itemId) then
            local value = eventItemDictConfig:Get(itemId)
            if value > 0 then
                listReward:Add(reward)
            end
        end
    end
    for i = 1, #dataConfig do
        local questId = dataConfig[i].id
        if questId ~= nil then
            listReward = List()
            checkCondition(i)
            rewardDict:Add(tonumber(questId), listReward)
        else
            checkCondition(i)
        end
    end
    self._bonusDailyQuestRewardDict:Add(dataId, rewardDict)
end

--- @return List
function EventLunarNewYearConfig:GetDailyQuestBonusReward(dataId, questId)
    if self._bonusDailyQuestRewardDict:IsContainKey(dataId) == false then
        self:_ReadBonusQuestRewardData(dataId)
    end
    --- @type Dictionary
    local rewardDict = self._bonusDailyQuestRewardDict:Get(dataId)
    return rewardDict:Get(questId)
end

return EventLunarNewYearConfig