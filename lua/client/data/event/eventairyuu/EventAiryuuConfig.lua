require "lua.client.data.Event.EventAiryuu.AiryuuExchangeItemData"

local COLLECTION_QUEST_PATH = "collection_quest.csv"
local TREASURE_QUEST_PATH = "treasure_quest.csv"
local TREASURE_RATE_PATH = "treasure_rate.csv"
local LOGIN_REWARD_PATH = "login_reward.csv"
local TREASURE_CONFIG_PATH = "treasure_config.csv"
local TRIAL_CHALLENGE_REWARD_PATH = "hero_trial/challenge_reward.csv"
local TRIAL_DEFENDER_TEAM_PATH = "hero_trial/defender_team.csv"
local TRIAL_HERO_AIRYUU_CONFIG_PATH = "hero_trial/hero_view.csv"
local TRIAL_STAMINA_PATH = "hero_trial/stamina_config.csv"
local TRIAL_VIP_BONUS_PATH = "hero_trial/vip_bonus.csv"

--- @class EventAiryuuConfig
EventAiryuuConfig = Class(EventAiryuuConfig)
function EventAiryuuConfig:Ctor(path)
    self.path = path
    ----- @type Dictionary
    --self.collectionQuestDict = nil
    ----- @type Dictionary
    --self.loginRewardDict = Dictionary()
    ----- @type Dictionary
    --self.treasureQuestDict = nil
    ----- @type Dictionary
    --self.treasureRateDict = Dictionary()
    -----@type List
    --self.listTreasureReward = List()
    --- @type Dictionary
    self.trialDefenderTeamDict = Dictionary()
    --- @type Dictionary
    self.trialChallengeRewardDict = Dictionary()
end

--- @return Dictionary
function EventAiryuuConfig:GetCollectionQuestConfig()
    --- @type Dictionary
    self.collectionQuestDict = Dictionary()
    local path = string.format("%s/%s", self.path, COLLECTION_QUEST_PATH)
    self.collectionQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    return self.collectionQuestDict
end

--- @return Dictionary
function EventAiryuuConfig:GetTreasureQuestConfig()
    --- @type Dictionary
    self.treasureQuestDict = Dictionary()
    local path = string.format("%s/%s", self.path, TREASURE_QUEST_PATH)
    self.treasureQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    return self.treasureQuestDict
end

--- @return Dictionary
function EventAiryuuConfig:GetLoginRewardConfig()
    --- @type Dictionary
    self.loginRewardDict = Dictionary()
    local path = string.format("%s/%s", self.path, LOGIN_REWARD_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local loginDayCount = #parserData
    for i = 1, loginDayCount do
        local data = parserData[i]
        local day = tonumber(data["day"])
        local dict = {}
        dict.moneyData = {}
        dict.moneyData.moneyType = tonumber(data["money_type"])
        dict.moneyData.moneyValue = tonumber(data["money_value"])
        ---@type RewardInBound
        dict.rewardInBound = RewardInBound.CreateBySingleParam(tonumber(data["res_type"]), tonumber(data["res_id"]), tonumber(data["res_number"]), tonumber(data["res_data"]))
        dict.isReclaim = (data["is_reclaim"])
        self.loginRewardDict:Add(tonumber(day), dict)
    end
    return self.loginRewardDict
end

function EventAiryuuConfig:GetLoginDayCount()
    local path = string.format("%s/%s", self.path, LOGIN_REWARD_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    return #parserData
end

--- @return Dictionary
function EventAiryuuConfig:GetTreasureRateConfig()
    --- @type List
    self.listTreasureReward = List()
    --- @type Dictionary
    self.treasureQuestDict = Dictionary()
    --- @type Dictionary
    self.treasureRateDict = Dictionary()
    local path = string.format("%s/%s", self.path, TREASURE_RATE_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local totalRate = 0
    for i = 1, #parserData do
        totalRate = totalRate + tonumber(parserData[i].rate)
    end
    for i = 1, #parserData do
        local data = parserData[i]
        local table = {}
        local group = tonumber(data["group"])
        local groupRate = tonumber(data["group_rate"])
        local id = tonumber(data["id"])
        table.rate = MathUtils.RoundDecimal(tonumber(data["rate"]) / totalRate * 100, 2)
        table.stock = tonumber(data["stock"])
        ---@type RewardInBound
        local rewardInBound = RewardInBound.CreateBySingleParam(tonumber(data["res_type"]), tonumber(data["res_id"]), tonumber(data["res_number"]), tonumber(data["res_data"])):GetIconData()
        rewardInBound.rate = MathUtils.RoundDecimal(tonumber(data["rate"]) / totalRate * 100, 2)
        ---@type RewardInBound
        table.rewardInBound = RewardInBound.CreateBySingleParam(tonumber(data["res_type"]), tonumber(data["res_id"]), tonumber(data["res_number"]), tonumber(data["res_data"]))
        self.listTreasureReward:Add(rewardInBound)
        self.treasureRateDict:Add(id, table)
    end
    return self.treasureQuestDict, self.listTreasureReward
end

function EventAiryuuConfig:GetTreasureFreeDailyConfig()
    local path = string.format("%s/%s", self.path, TREASURE_CONFIG_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local data = parserData[1]
    return tonumber(data["daily_open_free"])
end

--- @return Dictionary
function EventAiryuuConfig:GetTrialChallengeRewardConfig()
    local path = string.format("%s/%s", self.path, TRIAL_CHALLENGE_REWARD_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local difficulty
    local listReward
    for i = 1, #parserData do
        local data = parserData[i]
        if data["difficulty"] ~= nil then
            difficulty = tonumber(data["difficulty"])
            listReward = List()
        end
        local rewardInBound = RewardInBound.CreateBySingleParam(tonumber(data["res_type"]), tonumber(data["res_id"]), tonumber(data["res_number"]), tonumber(data["res_data"]))
        if data ~= nil then
            listReward:Add(rewardInBound)
        end
        self.trialChallengeRewardDict:Add(difficulty, listReward)
    end
    return self.trialChallengeRewardDict
end

--- @return Dictionary
function EventAiryuuConfig:GetTrialDefenderTeamConfig()
    self.trialDefenderTeamDict = Dictionary()
    local path = string.format("%s/%s", self.path, TRIAL_DEFENDER_TEAM_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    ---@type Dictionary
    local teamDict
    local difficulty
    for i = 1, #parserData do
        local data = parserData[i]
        if data["difficulty"] ~= nil then
            difficulty = tonumber(data["difficulty"])
            teamDict = Dictionary()
        end
        local id = tonumber(data["id"])
        local table = {}
        table.rate = tonumber(data["rate"])
        local tempData = DefenderTeamData(data)
        table.defenderTeamData = tempData.predefineTeamData
        table.powerTeam = tempData:GetPowerTeam()
        table.battleTeamInfor = tempData:GetBattleTeamInfo()
        teamDict:Add(id, table)

        if i == #parserData or parserData[i + 1]["difficulty"] ~= nil then
            self.trialDefenderTeamDict:Add(difficulty, teamDict)
        end
    end
    return self.trialDefenderTeamDict
end

function EventAiryuuConfig:GetTrialDefenderTeamConfigByDifficultyAndId(difficulty, id)
    if not self.trialDefenderTeamDict or self.trialDefenderTeamDict:Count() == 0 then
        self:GetTrialDefenderTeamConfig()
    end
    return self.trialDefenderTeamDict:Get(difficulty):Get(id)
end

--- @return Dictionary
function EventAiryuuConfig:GetTrialHeroAiryuuConfig()
    local path = string.format("%s/%s", self.path, TRIAL_HERO_AIRYUU_CONFIG_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local data = parserData[1]
    local tableData = {}
    tableData.heroId = tonumber(data["hero_id"])
    tableData.heroStar = tonumber(data["hero_star"])
    return tableData
end

--- @return Dictionary
function EventAiryuuConfig:GetTrialStaminaConfig()
    local path = string.format("%s/%s", self.path, TRIAL_STAMINA_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local data = parserData[1]
    local tableData = {}
    tableData.dailyFree = tonumber(data["daily_stamina_free"])
    tableData.moneyType = tonumber(data["money_type"])
    tableData.moneyValue = tonumber(data["money_value"])
    return tableData
end

--- @return Dictionary
function EventAiryuuConfig:GetTrialVipBonusConfig()
    --- @type List
    self.listTrialVipBonus = List()
    local path = string.format("%s/%s", self.path, TRIAL_VIP_BONUS_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    for i = 1, #parserData do
        local data = parserData[i]
        local tableData = {}
        tableData.vipMin = tonumber(data["vip_min"])
        tableData.vipMax = tonumber(data["vip_max"])
        tableData.numberBuyStamina = tonumber(data["number_buy_stamina"])
        self.listTrialVipBonus:Add(tableData)
    end
    return self.listTrialVipBonus
end

return EventAiryuuConfig