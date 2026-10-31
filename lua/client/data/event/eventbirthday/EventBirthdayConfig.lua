require "lua.client.data.Event.EventXmas.EventXmasLoginDataConfig"
require "lua.client.data.Purchase.LevelPass.GrowthPackLineConfig"
require "lua.client.data.Event.EventBirthday.EventBirthdayBossChallengeConfig"
local LOGIN_PATH = "login_reward.csv"
local IDLE_REWARD = "idle_reward.csv"
local DAILY_QUEST_PATH = "daily_quest.csv"
local ACCUMULATE_QUEST_PATH = "point_quest.csv"
local DARK_LIGHT_SELECT_SIDE = "dark_or_light/select_side_config.csv"
local GROWTH_PACK_BASIC = "/legacy_path/legacy_path_free_reward.csv"
local GROWTH_PACK_PREMIUM = "/legacy_path/hero_premium_line/%s_premium_line.csv"
local HERO_CUSTOMIZE_LINE = "/legacy_path/hero_premium_line/hero_customize_line.csv"
local BONUS_MISSION_BUNDLE_REWARD_PATH = "bundle/mission_bundle_config.csv"
local BONUS_WEEKLY_MISSION_BUNDLE_REWARD_PATH = "bundle/weekly_bundle_config.csv"
local BONUS_DAILY_QUEST_REWARD_PATH = "csv/event/event_birthday/data_%d/quest/daily_quest_pass_bonus_reward.csv"
local MISSION_QUEST_PASS_BONUS_REWARD = "csv/event/event_birthday/data_%d/quest/mission_quest_pass_bonus_reward.csv"
local DARK_LIGHT_QUEST_CONFIG = "dark_or_light/dark_light_quest.csv"
local DARK_LIGHT_HEROES_CONFIG = "dark_or_light/dark_light_for_client.csv"
local CHALLENGE_CONFIG = "boss/challenge_config.csv"

--- @class EventBirthdayConfig
EventBirthdayConfig = Class(EventBirthdayConfig)
function EventBirthdayConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.dailyQuestDict = nil
    --- @type Dictionary
    self.accumulateQuestDict = nil
    --- @type List
    self.rewardPool = List()
    --- @type Dictionary
    self.dictSelectSideConfig = nil
    --- @type Dictionary
    self.lineConfig = Dictionary()
    if path ~= nil then
        self:GetHeroSelection()
        self.bossConfig = EventBirthdayBossChallengeConfig(path)
        self:ReadSelectSideConfig()
    end
    --- @type Dictionary
    self._bonusBundleRewardDict = Dictionary()
    --- @type Dictionary
    self._bonusWeeklyBundleRewardDict = Dictionary()
    --- @type Dictionary
    self._bonusDailyQuestBirthdayRewardDict = Dictionary()
    --- @type Dictionary
    self._selectionHeroesNodeDict = Dictionary()
    --- @type Dictionary
    self._bonusEventQuestBirthdayRewardDict = Dictionary()
end

function EventBirthdayConfig:GetHeroSelection()
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

--- @type Dictionary -- <number, QuestElementConfig>
function EventBirthdayConfig:GetQuestConfig()
    if self.dailyQuestDict == nil then
        self.dailyQuestDict = self:InitQuest(DAILY_QUEST_PATH)
    end
    return self.dailyQuestDict
end

--- @type Dictionary -- <number, QuestElementConfig>
function EventBirthdayConfig:GetAccumulateQuestConfig()
    if self.accumulateQuestDict == nil then
        self.accumulateQuestDict = self:InitQuest(ACCUMULATE_QUEST_PATH)
    end
    return self.accumulateQuestDict
end

--- @return Dictionary
function EventBirthdayConfig:InitQuest(path)
    local path = string.format("%s/%s", self.path, path)
    return QuestElementConfig.ReadQuestConfigFromPath(path)
end

--- @return GrowthPackLineConfig
--- @param dataId number
function EventBirthdayConfig:GetLegacyPathConfig(dataId, heroId)
    self:_InitLineConfig(dataId, heroId)
    return self.lineConfig:Get(dataId)
end

--- @param dataId number
function EventBirthdayConfig:_InitLineConfig(dataId, heroId)
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

--- @return EventBirthdayBossChallengeConfig
function EventBirthdayConfig:GetMaxPointLegacyPath()
    ---@param v GrowthPackLineConfig
    for _, v in  pairs(self.lineConfig:GetItems()) do
        return v.listMilestone:Get(v.listMilestone:Count()).number
    end
end

--- @return EventBirthdayBossChallengeConfig
function EventBirthdayConfig:GetBossChallengeConfig()
    return self.bossConfig
end

--- @return Dictionary
function EventBirthdayConfig:GetLoginConfig()
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

--- @return Dictionary
function EventBirthdayConfig:IsNewLogin()
    if self.isReclaim ~= nil then
        return self.isReclaim
    end
end

--- @return {listGoldenTimeReward : List, lastDuration : number}
function EventBirthdayConfig:GetGoldenTimeConfig()
    if self._goldenTimeConfig == nil then
        local path = string.format("%s/%s", self.path, IDLE_REWARD)
        require "lua.client.data.Event.GoldenTimeConfig"
        self._goldenTimeConfig = GoldenTimeConfig(path)
    end
    return self._goldenTimeConfig
end

--- @return List
function EventBirthdayConfig:GetListExchangeConfig()
    if self.listExchange == nil then
        local path = string.format("%s/%s", self.path, "exchange_reward.csv")
        require "lua.client.data.Event.ExchangeEventConfig"
        self.listExchange = ExchangeEventConfig.GetListExchangeConfigPath(path)
    end
    return self.listExchange
end

---@return Dictionary
function EventBirthdayConfig:ReadSelectSideConfig()
    if self.dictSelectSideConfig == nil then
        local path = string.format("%s/%s", self.path, DARK_LIGHT_SELECT_SIDE)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Read Event Birthday Select Side Config  nil %s", path))
            return
        end
        self.dictSelectSideConfig = Dictionary()
        for i = 1, #parsedData do
            if parsedData[i].faction_id ~= nil then
                self.dictSelectSideConfig:Add(tonumber(parsedData[i].faction_id), tonumber(parsedData[i].hero_id))
            end
        end
    end
    return self.dictSelectSideConfig
end

---@return number
function EventBirthdayConfig:GetSelectHeroIdFromSide(index)
    if self.dictSelectSideConfig == nil then
        self:ReadSelectSideConfig()
    end
    return self.dictSelectSideConfig:Get(index)
end

--- @return TreasureRewardConfig
function EventBirthdayConfig:ReadCsvTreasure()
    if self.dictTreasureReward == nil then
        require "lua.client.data.Event.EventNewHeroTreasure.TreasureRewardConfig"
        local path = string.format("%s/%s", self.path, "treasure_map/island_reward.csv")
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
function EventBirthdayConfig:GetTreasureRewardConfig(line, index)
    self:ReadCsvTreasure()
    return self.dictTreasureReward:Get(line):Get(index)
end

--- @return number
function EventBirthdayConfig:GetTreasureLine()
    self:ReadCsvTreasure()
    return self.dictTreasureReward:Count()
end

--- @return List TreasureRewardConfig
function EventBirthdayConfig:GetListTreasureRewardConfig(line)
    self:ReadCsvTreasure()
    return self.dictTreasureReward:Get(line)
end

--- @return FinalTreasureRewardConfig
function EventBirthdayConfig:GetFinalTreasureRewardConfig(index)
    self:ReadCsvLineComplete()
    return self.dictListRewardLineComplete:Get(index)
end

--- @return Dictionary
function EventBirthdayConfig:GetDictRewardLineComplete()
    self:ReadCsvLineComplete()
    return self.dictListRewardLineComplete
end

---@return List
function EventBirthdayConfig:GetListWheelConfig()
    if self.listWheelConfig == nil then
        require "lua.client.data.Event.EventBirthday.EventBirthdayWheelConfig"
        local path = string.format("%s/%s", self.path, "wheel_config.csv")
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("ReadDataWheel nil %s", path))
            return
        end
        self.listWheelConfig = List()
        ---@type EventBirthdayWheelConfig
        local cache = nil
        for i = 1, #parsedData do
            if parsedData[i].round_id ~= nil then
                cache = EventBirthdayWheelConfig.CreateByParams(parsedData[i])
                self.listWheelConfig:Add(cache)
            else
                cache:AddReward(parsedData[i])
            end
        end
    end
    return self.listWheelConfig
end

--- @return RewardInBound
function EventBirthdayConfig:GetMissionBundleBonusReward(dataId, bundleId)
    if self._bonusBundleRewardDict:IsContainKey(dataId) == false then
        self:_ReadBonusRewardData(dataId)
    end
    --- @type Dictionary
    local rewardDict = self._bonusBundleRewardDict:Get(dataId)
    if rewardDict:IsContainKey(bundleId) then
        return rewardDict:Get(bundleId)
    else
        print("bundleId not found |", "android_package_name: ", bundleId)
    end
end

function EventBirthdayConfig:_ReadBonusRewardData(dataId)
    local rewardDict = Dictionary()
    local path = string.format("%s/%s", self.path, BONUS_MISSION_BUNDLE_REWARD_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local bundleId = nil
    for i = 1, #parsedData do
        if parsedData[i].android_package_name ~= nil then
            bundleId = string.sub(parsedData[i].android_package_name, string.len(parsedData[i].android_package_name) - 25, string.len(parsedData[i].android_package_name))
            local rewardInBound = RewardInBound.CreateByParams(parsedData[i])
            rewardDict:Add(bundleId, rewardInBound)
        end
    end
    self._bonusBundleRewardDict:Add(dataId, rewardDict)
end

--- @return RewardInBound
function EventBirthdayConfig:GetWeeklyBundleBonusReward(dataId, bundleId)
    if self._bonusWeeklyBundleRewardDict:IsContainKey(dataId) == false then
        self:_ReadWeeklyBonusRewardData(dataId)
    end
    --- @type Dictionary
    local rewardDict = self._bonusWeeklyBundleRewardDict:Get(dataId)
    if rewardDict:IsContainKey(bundleId) then
        return rewardDict:Get(bundleId)
    else
        print("bundleId not found |", "android_package_name: ", bundleId)
    end
end

function EventBirthdayConfig:_ReadWeeklyBonusRewardData(dataId)
    local rewardDict = Dictionary()
    local path = string.format("%s/%s", self.path, BONUS_WEEKLY_MISSION_BUNDLE_REWARD_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local bundleId = nil
    for i = 1, #parsedData do
        if parsedData[i].android_package_name ~= nil then
            bundleId = string.sub(parsedData[i].android_package_name, string.len(parsedData[i].android_package_name) - 25, string.len(parsedData[i].android_package_name))
            local rewardInBound = RewardInBound.CreateByParams(parsedData[i])
            rewardDict:Add(bundleId, rewardInBound)
        end
    end
    self._bonusWeeklyBundleRewardDict:Add(dataId, rewardDict)
end

--- @return Dictionary
function EventBirthdayConfig:GetQuestConfigDict()
    if self.questConfigDict == nil then
        local path = string.format("%s/%s", self.path, DARK_LIGHT_QUEST_CONFIG)
        self.questConfigDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    end
    return self.questConfigDict
end

--- @return List
function EventBirthdayConfig:GetDailyQuestBonusReward(dataId, questId)
    if self._bonusDailyQuestBirthdayRewardDict:IsContainKey(dataId) == false then
        self:_ReadBonusQuestRewardData(dataId)
    end
    --- @type Dictionary
    local rewardDict = self._bonusDailyQuestBirthdayRewardDict:Get(dataId)
    return rewardDict:Get(questId)
end

--- @return List
function EventBirthdayConfig:GetEventBonusReward(dataId, questId, eventTimeType)
    if self._bonusEventQuestBirthdayRewardDict:IsContainKey(dataId) == false then
        self:_ReadBonusEventQuestRewardData(dataId)
    end
    --- @type Dictionary
    local eventRewardDict = self._bonusEventQuestBirthdayRewardDict:Get(dataId)
    --- @type Dictionary
    local rewardDict = eventRewardDict:Get(eventTimeType)
    return rewardDict:Get(questId)
end

function EventBirthdayConfig:_ReadBonusQuestRewardData(dataId)
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
    self._bonusDailyQuestBirthdayRewardDict:Add(dataId, rewardDict)
end

function EventBirthdayConfig:_ReadBonusEventQuestRewardData(dataId)
    local rewardDict = Dictionary()
    local eventRewardDict = Dictionary()
    local dataConfig = CsvReaderUtils.ReadAndParseLocalFile(string.format(MISSION_QUEST_PASS_BONUS_REWARD, dataId))
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
        local eventType = dataConfig[i].event_type
        if eventType == nil then
            local questId = dataConfig[i].id
            if questId ~= nil then
                listReward = List()
                checkCondition(i)
                rewardDict:Add(tonumber(questId), listReward)
            else
                checkCondition(i)
            end
        else
            local questId = dataConfig[i].id
            rewardDict = Dictionary()
            listReward = List()
            checkCondition(i)
            rewardDict:Add(tonumber(questId), listReward)
            eventRewardDict:Add(tonumber(eventType), rewardDict)
        end
    end
    self._bonusEventQuestBirthdayRewardDict:Add(dataId, eventRewardDict)
end

--- @return List
function EventBirthdayConfig:GetListHeroNodeConfig(slotId)
    if self._selectionHeroesNodeDict:IsContainKey(slotId) == false then
        self:_ReadListHeroNodeConfig()
    end
    return self._selectionHeroesNodeDict:Get(slotId)
end

function EventBirthdayConfig:_ReadListHeroNodeConfig()
    local path = string.format("%s/%s", self.path, DARK_LIGHT_HEROES_CONFIG)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local heroesList = List()
    for i = 1, #parsedData do
        local slotId = tonumber(parsedData[i].slot_id)
        if slotId ~= nil then
            heroesList = List()
            self._selectionHeroesNodeDict:Add(slotId, heroesList)
        end
        heroesList:Add(parsedData[i].hero_id)
    end
end

---@return {moneyType, moneyValue, blockDuration}
function EventBirthdayConfig:GetChallengeConfig()
    local path = string.format("%s/%s", self.path, CHALLENGE_CONFIG)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    ---@type {moneyType, moneyValue, blockDuration}
    local data = {}
    data.moneyType = tonumber(parsedData[1].money_type)
    data.moneyValue = tonumber(parsedData[1].money_value)
    data.blockDuration = tonumber(parsedData[1].block_duration)
    return data
end

return EventBirthdayConfig