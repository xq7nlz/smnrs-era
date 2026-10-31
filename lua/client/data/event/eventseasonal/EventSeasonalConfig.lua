require "lua.client.data.Event.EventSeasonal.EventSeasonalExchangeItemData"
require "lua.client.data.Event.BossChallengeRewardMilestoneData"

local BONUS_DAILY_QUEST_REWARD_PATH = "csv/event/event_seasonal/data_%d/daily_quest_bonus_reward.csv"
local DAILY_CHECKIN_PATH = "login_reward.csv"
local EXCHANGE_PATH = "exchange_reward.csv"
local EXCHANGE_BALL_PATH = "exchange_ball.csv"
local SELECT_HERO_PATH = "select_hero_config.csv"
local THROW_BALL_REWARD_PATH = "water_ball_reward_rate.csv"
local QUIZ_FINAL_REWARD_PATH = "quiz_final_reward.csv"
local EXCHANGE_BALL_PRICE_PATH = "seasonal_box/seasonal_water_ball_exchange_config.csv"
local BOSS_EVENT_HERO_PATH = "seasonal_boss/event_hero.csv"
local BOSS_STAMINA_CONFIG_PATH = "seasonal_boss/stamina_config.csv"
local BOSS_DEFENDER_TEAM_CONFIG = "seasonal_boss/defender_team.csv"
local BOSS_REWARD_CONFIG = "seasonal_boss/reward_config.csv"
local BOSS_CHALLENGE_CONFIG = "seasonal_boss/challenge_config.csv"
local LEADER_BOSS_CONFIG = "seasonal_boss/leader_board_reward.csv"
local MOJITO_CONFIG = "seasonal_mojito/mojito_cost.csv"
local MOJITO_REWARD_PATH = "seasonal_mojito/collection_quest.csv"
local MOJITO_COLLECTION_QUEST_PATH = "seasonal_mojito/collection_quest.csv"

--- @class EventSeasonalConfig
EventSeasonalConfig = Class(EventSeasonalConfig)
function EventSeasonalConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self._bonusDailyQuestRewardDict = Dictionary()
end

-----------------------------------------LoginConfig-----------------------------------------

--- @return Dictionary
function EventSeasonalConfig:GetLoginRewardConfig()
    --- @type Dictionary
    self.loginRewardDict = Dictionary()
    local day
    --- @type List
    local listReward
    local path = string.format("%s/%s", self.path, DAILY_CHECKIN_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local loginDayCount = #parserData
    for i = 1, loginDayCount do
        local data = parserData[i]
        local dict = {}
        if tonumber(data["day"]) then
            day = tonumber(data["day"])
            listReward = List()
            dict.moneyData = {}
            dict.moneyData.moneyType = tonumber(data["money_type"])
            dict.moneyData.moneyValue = tonumber(data["money_value"])
            dict.isReclaim = data["is_reclaim"]
            listReward:Add(RewardInBound.CreateBySingleParam(tonumber(data["res_type"]), tonumber(data["res_id"]), tonumber(data["res_number"]), tonumber(data["res_data"])))
            dict.listReward = listReward
            self.loginRewardDict:Add(day, dict)
        else
            local temp = self.loginRewardDict:Get(day)
            temp.listReward:Add(RewardInBound.CreateBySingleParam(tonumber(data["res_type"]), tonumber(data["res_id"]), tonumber(data["res_number"]), tonumber(data["res_data"])))
            self.loginRewardDict:Add(day, temp)
        end
    end
    return self.loginRewardDict
end

function EventSeasonalConfig:GetLoginDayCount()
    local path = string.format("%s/%s", self.path, DAILY_CHECKIN_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    return #parserData
end

-----------------------------------------ExchangeConfig-----------------------------------------

--- @return Dictionary {number | List}
function EventSeasonalConfig:GetExchangeGroupRewardConfig()
    --- @type Dictionary
    self.dictGroupReward = Dictionary()
    local path = string.format("%s/%s", self.path, EXCHANGE_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    ---@type List
    local listReward
    local lastGroupId = -1
    for i = 1, #parserData do
        local data = parserData[i]
        local groupId = tonumber(data["group"])
        if data["group"] and groupId ~= lastGroupId then
            lastGroupId = groupId
            listReward = List()
            self.dictGroupReward:Add(groupId, listReward)
        end
        if listReward then
            listReward:Add(EventSeasonalExchangeItemData.CreateByParams(data))
        end
    end
    return self.dictGroupReward
end

-----------------------------------------BonusDailyQuest-----------------------------------------

--- @return RewardInBound
function EventSeasonalConfig:GetDailyQuestBonusReward(dataId, questId)
    if self._bonusDailyQuestRewardDict:IsContainKey(dataId) == false then
        self:_ReadBonusRewardData(dataId)
    end
    --- @type Dictionary
    local rewardDict = self._bonusDailyQuestRewardDict:Get(dataId)
    return rewardDict:Get(questId)
end

function EventSeasonalConfig:_ReadBonusRewardData(dataId)
    local rewardDict = Dictionary()
    local dataConfig = CsvReaderUtils.ReadAndParseLocalFile(string.format(BONUS_DAILY_QUEST_REWARD_PATH, dataId))
    local listReward = List()
    for i = 1, #dataConfig do
        local questId = dataConfig[i].id
        if questId ~= nil then
            listReward = List()
            listReward:Add(RewardInBound.CreateByParams(dataConfig[i]))
            rewardDict:Add(tonumber(questId), listReward)
        else
            listReward:Add(RewardInBound.CreateByParams(dataConfig[i]))
        end
    end
    self._bonusDailyQuestRewardDict:Add(dataId, rewardDict)
end

-----------------------------------------SummerGame-----------------------------------------

--- @return Dictionary
function EventSeasonalConfig:GetBallExchange()
    --- @type Dictionary
    local exchangeBallDict = Dictionary()
    local path = string.format("%s/%s", self.path, EXCHANGE_BALL_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    for i = 1, #parserData do
        local data = parserData[i]
        local id = tonumber(data["id"])
        ---@type RewardInBound
        local reward = RewardInBound.CreateByParams(data)
        exchangeBallDict:Add(id, reward)
    end
    return exchangeBallDict
end

--- @return Dictionary
function EventSeasonalConfig:GetDictHeroSelect()
    local dictHeroSelect = Dictionary()
    local path = string.format("%s/%s", self.path, SELECT_HERO_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local slotId
    local lastSlotId = -1
    ---@type  {ballId, targetBall, listHeroId}
    local dictData
    ---@type List
    local listHeroId
    for i = 1, #parserData do
        local data = parserData[i]
        slotId = tonumber(data["slot_id"])
        if slotId and slotId ~= lastSlotId then
            lastSlotId = slotId
            dictData = {}
            dictData.ballId = tonumber(data["ball_id"])
            dictData.targetBall = tonumber(data["total_ball"])
            listHeroId = List()
            dictHeroSelect:Add(slotId, dictData)
            dictData.listHeroId = listHeroId
        end
        local heroId = tonumber(data["hero_id"])
        ---@type HeroResource
        local heroResource = HeroResource(heroId)
        heroResource:SetData(-1, heroId, 5, 1)
        listHeroId:Add(HeroIconData.CreateByHeroResource(heroResource))
    end
    return dictHeroSelect
end

--- @return List
function EventSeasonalConfig:GetBallThrowReward()
    --- @type List
    local listTreasureReward = List()
    local path = string.format("%s/%s", self.path, THROW_BALL_REWARD_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local totalRate = 0
    for i = 1, #parserData do
        totalRate = totalRate + tonumber(parserData[i].rate)
    end
    for i = 1, #parserData do
        local data = parserData[i]
        ---@type RewardInBound
        local rewardInBound = RewardInBound.CreateBySingleParam(tonumber(data["res_type"]), tonumber(data["res_id"]), tonumber(data["res_number"]), tonumber(data["res_data"])):GetIconData()
        rewardInBound.rate = MathUtils.RoundDecimal(tonumber(data["rate"]) / totalRate * 100, 2)
        listTreasureReward:Add(rewardInBound)
    end
    return listTreasureReward
end

--- @return {moneyType, moneyValue}
function EventSeasonalConfig:GetBallExchangePrice()
    local path = string.format("%s/%s", self.path, EXCHANGE_BALL_PRICE_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local data = parserData[1]
    local moneyData = {}
    moneyData.moneyType = tonumber(data["money_type"])
    moneyData.moneyValue = tonumber(data["money_value"])
    return moneyData
end

--- @return RewardInBound
function EventSeasonalConfig:GetSummerGameFinalReward()
    local path = string.format("%s/%s", self.path, QUIZ_FINAL_REWARD_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local data = parserData[1]
    return RewardInBound.CreateBySingleParam(tonumber(data["res_type"]), tonumber(data["res_id"]), tonumber(data["res_number"]), tonumber(data["res_data"]))
end

--------------------------------------------RoyalChallenge-----------------------------------------

--- @return {heroId, skinId}
function EventSeasonalConfig:GetChallengeHeroData()
    local path = string.format("%s/%s", self.path, BOSS_EVENT_HERO_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local data = {}
    data.heroId = tonumber(parserData[1].hero_id)
    data.skinId = tonumber(parserData[1].skin_id)
    return data
end

--- @return {moneyType, moneyValue, maxNumberBuy, numberStaminaDefault}
function EventSeasonalConfig:GetChallengeStaminaConfig()
    local path = string.format("%s/%s", self.path, BOSS_STAMINA_CONFIG_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    ---@type {moneyType, moneyValue, maxNumberBuy, numberStaminaDefault}
    local data = {}
    data.moneyType = tonumber(parserData[1].money_type)
    data.moneyValue = tonumber(parserData[1].money_value)
    data.maxNumberBuy = tonumber(parserData[1].max_number_buy)
    data.numberStaminaDefault = tonumber(parserData[1].number_stamina_default)
    return data
end

--- @return DefenderTeamData
function EventSeasonalConfig:GetDefenderTeamData()
    require "lua.client.data.DefenderTeamData"
    local path = string.format("%s/%s", self.path, BOSS_DEFENDER_TEAM_CONFIG)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    --- @type DefenderTeamData
    local bossDefenderTeamData = DefenderTeamData(parsedData[1])
    return bossDefenderTeamData
end

--- @return Dictionary
function EventSeasonalConfig:GetBossDamageRewardConfig()
    local path = string.format("%s/%s", self.path, BOSS_REWARD_CONFIG)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local listBossDamageRewardConfig = List()
    --- @type BossChallengeRewardMilestoneData
    local milestoneConfig = nil
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.milestone_damage ~= nil then
            milestoneConfig = BossChallengeRewardMilestoneData()
            milestoneConfig:ParsedData(data)
            listBossDamageRewardConfig:Add(milestoneConfig)
        else
            milestoneConfig:AddData(data)
        end
    end
    return listBossDamageRewardConfig
end

--- @return {moneyType, moneyValue, blockDuration}
function EventSeasonalConfig:GetChallengeConfig()
    local path = string.format("%s/%s", self.path, BOSS_CHALLENGE_CONFIG)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    ---@type {moneyType, moneyValue, blockDuration}
    local data = {}
    data.moneyType = tonumber(parserData[1].money_type)
    data.moneyValue = tonumber(parserData[1].money_value)
    data.blockDuration = tonumber(parserData[1].block_duration)
    return data
end

--- @return List
function EventSeasonalConfig:GetArenaConfigList()
    local arenaConfigList = List()
    local path = string.format("%s/%s", self.path, LEADER_BOSS_CONFIG)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    ---@type ArenaRewardRankingConfig
    local arenaRewardRankingConfig
    for i = 1, #parsedData do
        local lineData = parsedData[i]
        if lineData["min"] ~= nil then
            require "lua.client.data.Arena.ArenaRewardRankingConfig"
            ---@type ArenaRewardRankingConfig
            arenaRewardRankingConfig = ArenaRewardRankingConfig()
            arenaConfigList:Add(arenaRewardRankingConfig)
            arenaRewardRankingConfig.topMin = tonumber(lineData["min"])
            arenaRewardRankingConfig.topMax = tonumber(lineData["max"])
            arenaRewardRankingConfig.listRewardItem = List()
        end
        ---@type ItemIconData
        local itemIconData = ItemIconData.CreateInstance(tonumber(lineData["res_type"]), tonumber(lineData["res_id"]), tonumber(lineData["res_number"]))
        arenaRewardRankingConfig.listRewardItem:Add(itemIconData)
    end
    return arenaConfigList
end

function EventSeasonalConfig:GetListRewardByRank(rank)
    local list = self:GetArenaConfigList()
    for i = list:Count(), 1, -1 do
        ---@type ArenaRewardRankingConfig
        local arenaRewardRankingConfig = list:Get(i)
        if (rank >= arenaRewardRankingConfig.topMin) then
            return arenaRewardRankingConfig.listRewardItem
        end
    end
end

-------------------------------MojitoCreator-----------------------------------------

--- @return {moneyType, moneyValue}
function EventSeasonalConfig:GetMojitoConfig()
    local path = string.format("%s/%s", self.path, MOJITO_CONFIG)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    ---@type {moneyType, moneyValue}
    local data = {}
    data.moneyType = tonumber(parserData[1].money_type)
    data.moneyValue = tonumber(parserData[1].money_value)
    return data
end

-------------------------------BonusDailyQuest-----------------------------------------

--- @return Dictionary
function EventSeasonalConfig:GetCollectionQuestConfig()
    --- @type Dictionary
    self.collectionQuestDict = Dictionary()
    local path = string.format("%s/%s", self.path, MOJITO_COLLECTION_QUEST_PATH)
    self.collectionQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    return self.collectionQuestDict
end

return EventSeasonalConfig