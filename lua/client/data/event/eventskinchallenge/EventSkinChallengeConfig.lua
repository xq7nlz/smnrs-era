require "lua.client.data.Event.EventSkinChallenge.SelectionRewardsConfig"

local SELECT_SKIN_PATH = "select_skin_config.csv"
local DEFENDER_TEAM = "battle/daily_defender_team.csv"
local CHALLENGE_QUEST_PATH = "quest/challenge_quest.csv"
local FINAL_REWARD_CONFIG_PATH = "final_reward_config.csv"
local CHALLENGE_REWARD_CONFIG_PATH = "quest/instant_quest_reward.csv"

--- @class EventSkinChallengeConfig
EventSkinChallengeConfig = Class(EventSkinChallengeConfig)
function EventSkinChallengeConfig:Ctor(path)
    self.path = path
    --- @type List
    self.listSelectSkin = List()
    --- @type Dictionary
    self.dictDefenderTeam = Dictionary()

    self.backgroundConfig = nil

    ---@type Dictionary
    self.dayChallengeDict = Dictionary()

    ---@type RewardInBound
    ---
    self.finalRewardInBound = nil

    ---@type Dictionary|RewardInBound
    self.challengeRewardDict = Dictionary()
end

--- @return Dictionary
function EventSkinChallengeConfig:GetCollectionQuestConfig()
    if self.collectionQuestDict == nil then
        local path = string.format("%s/%s", self.path, CHALLENGE_QUEST_PATH)
        self.collectionQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    end
    return self.collectionQuestDict
end

--- @return List
function EventSkinChallengeConfig:GetSelectSkinConfig()
    if self.listSelectSkin:Count() < 1 then
        local path = string.format("%s/%s", self.path, SELECT_SKIN_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        for i = 1, #parsedData do
            local data = parsedData[i]
            self.listSelectSkin:Add(tonumber(data.skin_id))
        end
    end
    return self.listSelectSkin
end

--- @return List
function EventSkinChallengeConfig:GetSkinIdBySelectionId(selectionId)
    return self:GetSelectSkinConfig():Get(selectionId)
end

--- @return BattleTeamInfo
function EventSkinChallengeConfig:GetListLineupRecommendation(id)
    if self.dictDefenderTeam:Count() == 0 then
        local path = string.format("%s/%s", self.path, DEFENDER_TEAM)
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(path)
        for _, data in pairs(dataParse) do
            if data.background_config ~= nil then
                self.backgroundConfig = tonumber(data.background_config)
            end
            if data.id ~= nil then
                local defenderTeamData = DefenderTeamData(data)
                self.dictDefenderTeam:Add(tonumber(data.id), defenderTeamData)
            end
        end
    end
    return self.dictDefenderTeam:Get(id)
end

function EventSkinChallengeConfig:GetBackgroundId()
    if self.backgroundConfig == nil then
        local path = string.format("%s/%s", self.path, DEFENDER_TEAM)
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(path)
        for _, data in pairs(dataParse) do
            if data.background_config ~= nil then
                self.backgroundConfig = tonumber(data.background_config)
                break
            end
        end
    end
    return self.backgroundConfig
end

function EventSkinChallengeConfig:GetDayChallengeDict()
    if self.dayChallengeDict:Count() < 1 then
        local path = string.format("%s/%s", self.path, CHALLENGE_QUEST_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        local dayNumber
        for i = 1, #parsedData do
            if tonumber(parsedData[i].day) ~= nil then
                dayNumber = tonumber(parsedData[i].day)
            end
            local questId = tonumber(parsedData[i].quest_id)
            self.dayChallengeDict:Add(questId, dayNumber)
        end
    end
    return self.dayChallengeDict
end

function EventSkinChallengeConfig:GetFinalRewardInBound()
    if self.finalRewardInBound == nil then
        local path = string.format("%s/%s", self.path, FINAL_REWARD_CONFIG_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        for i = 1, #parsedData do
            if parsedData[i].money_type ~= nil then
                self.finalRewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, tonumber(parsedData[i].money_type), tonumber(parsedData[i].money_value))
            end
        end
    end
    return self.finalRewardInBound
end

function EventSkinChallengeConfig:GetChallengeRewardDict()
    if self.challengeRewardDict:Count() < 1 then
        --self:ReadChallengeRewardDict()
        self:ReadChallengeRewardDict2()
    end
    return self.challengeRewardDict
end

--- @return SelectionRewardsConfig
function EventSkinChallengeConfig:GetDictRewardChallengeByDay(dayId)
    if self.challengeRewardDict:Count() < 1 then
        --self:ReadChallengeRewardDict()
        self:ReadChallengeRewardDict2()
    end
    return self.challengeRewardDict:Get(dayId)
end

--- @return SelectionRewardsConfig
function EventSkinChallengeConfig:GetListRewardChallengeByDay(dayId)
    if self.challengeRewardDict:Count() == 0 then
        self:ReadChallengeRewardDict2()
    end
    local listReward = List()
    listReward:Add(self.challengeRewardDict:Get(dayId))
    return listReward
end

function EventSkinChallengeConfig:ReadChallengeRewardDict()
    local path = string.format("%s/%s", self.path, CHALLENGE_REWARD_CONFIG_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    --- @type SelectionRewardsConfig
    local selectionRewardsConfig
    for i = 1, #parsedData do
        if parsedData[i].day ~= nil then
            selectionRewardsConfig = SelectionRewardsConfig()
            self.challengeRewardDict:Add(tonumber(parsedData[i].day), selectionRewardsConfig)
        end
        local selectionId = tonumber(parsedData[i].selection_id)
        --- @type ItemIconData
        local itemIconData = RewardInBound.CreateBySingleParam(tonumber(parsedData[i].selection_res_type), tonumber(parsedData[i].selection_res_id), tonumber(parsedData[i].selection_res_number)):GetIconData()
        selectionRewardsConfig:AddSelectionReward(selectionId, itemIconData)
    end
end

function EventSkinChallengeConfig:ReadChallengeRewardDict2()
    local path = string.format("%s/%s", self.path, CHALLENGE_REWARD_CONFIG_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    for i = 1, #parsedData do
        local day
        if parsedData[i].day ~= nil then
            day = tonumber(parsedData[i].day)
        end
        --- @type ItemIconData
        local itemIconData = RewardInBound.CreateBySingleParam(tonumber(parsedData[i].res_type), tonumber(parsedData[i].res_id), tonumber(parsedData[i].res_number)):GetIconData()
        self.challengeRewardDict:Add(tonumber(day), itemIconData)
    end
end

return EventSkinChallengeConfig