local DAILY_QUEST_PATH = "daily_quest/daily_quest_reward.csv"
local DEFENDER_TEAM = "challenge/defender_team.csv"
local DEFENDER_TEAM_LOOP = "challenge/final_stage_team_pool.csv"
local TRIAL_HERO_STAT = "challenge/trial_hero_stat.csv"
local REWARD_RANKING = "challenge/reward_ranking_config.csv"
local BOSS_CHALLENGE_TOWER_REWARD_PATH = "challenge/stage_reward.csv"
local BOSS_CHALLENGE_TOWER_PREMIUM_REWARD_PATH = "challenge/premium_pass_reward.csv"
local BOSS_CHALLENGE_TOWER_LOOP_REWARD_PATH = "challenge/final_stage_reward.csv"
local BOSS_CHALLENGE_CONFIG = "challenge/challenge_config.csv"

require("lua.client.data.Event.EventBossChallenge.BossChallengeRewardRankingConfig")

--- @class EventBossChallengeConfig
EventBossChallengeConfig = Class(EventBossChallengeConfig)
function EventBossChallengeConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.dictLineUpRecommend = Dictionary()
    --- @type Dictionary
    self.dictLineUpLoopRecommend = Dictionary()
    --- @type Dictionary
    self.heroDict = Dictionary()
    --- @type Dictionary
    self.groupHeroDict = Dictionary()
    self.listRankingReward, self.totalRankType = self:ReadRankingData()
    self.listRankingReward:SortWithMethod(EventBossChallengeConfig.SortBossChallengeRewardRanking)
end

--- @return {moneyType, moneyValue, blockDuration, avgWinTicker}
function EventBossChallengeConfig:GetChallengeConfig()
    local path = string.format("%s/%s", self.path, BOSS_CHALLENGE_CONFIG)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local data = parserData[1]
    local eventDataConfig = {}
    eventDataConfig.moneyType = tonumber(data["money_type"])
    eventDataConfig.moneyValue = tonumber(data["money_value"])
    eventDataConfig.blockDuration = tonumber(data["block_duration"])
    eventDataConfig.avgWinTicker = tonumber(data["avg_win_ticket"])
    return eventDataConfig
end

--- @return List
function EventBossChallengeConfig:ReadRankingData()
    local path = string.format("%s/%s", self.path, REWARD_RANKING)
    local listReward = List()
    local totalArenaRankType = 0
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    ---@type number
    local rankType
    ---@type number
    local bossMin
    ---@type number
    local bossMax
    --- @type BossChallengeRewardRankingConfig
    local data
    for i = 1, #parsedData do
        if parsedData[i]["rank_type"] ~= nil then
            data = BossChallengeRewardRankingConfig()
            data:ParseCsv(parsedData[i])
            rankType = data.rankType
            bossMin = data.bossMin
            bossMax = data.bossMax
            data:AddReward(parsedData[i])
            listReward:Add(data)
            totalArenaRankType = totalArenaRankType + 1
        else
            data = listReward:Get(listReward:Count())
            data.rankType = rankType
            data.bossMin = bossMin
            data.bossMax = bossMax
            data:AddReward(parsedData[i])
        end
    end
    return listReward, totalArenaRankType
end

--- @return List
--- @param elo Number
function EventBossChallengeConfig:GetRankingTypeByScore(score)
    local listRankingReward     
    listRankingReward = self.listRankingReward
    if score ~= nil then
        ---@param v BossChallengeRewardRankingConfig
        for _, v in ipairs(listRankingReward:GetItems()) do
            if (v.bossMin <= score or v.bossMin < 0) and (v.bossMax >= score or v.bossMax < 0) then
                return v.rankType
            end
        end
    end
    return listRankingReward:Get(listRankingReward:Count()).rankType
end

--- @return BossChallengeRewardRankingConfig
---@param x BossChallengeRewardRankingConfig
---@param y BossChallengeRewardRankingConfig
function EventBossChallengeConfig.SortBossChallengeRewardRanking(x, y)
    if (x.rankType > y.rankType) then
        return -1
    elseif (x.rankType < y.rankType) then
        return 1
    end
end

--- @return Dictionary
function EventBossChallengeConfig:GetDailyQuestConfig()
    local path = string.format("%s/%s", self.path, DAILY_QUEST_PATH)
    local dailyQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    return dailyQuestDict
end

function EventBossChallengeConfig:InitBossChallengeTowerConfig()
    local path = string.format("%s/%s", self.path, DEFENDER_TEAM)
    local levelDesignContent = CsvReaderUtils.ReadAndParseLocalFile(path)
    require "lua.client.scene.ui.home.uiEventBossChallenge.eventLayout.challenge_tower.BossChallengeTowerConfig"
    self.campaignStageConfig = BossChallengeTowerConfig()
    self.campaignStageConfig:ParseCsv(levelDesignContent)
end

--- @return DefenderTeamData
--- @param stageId number
function EventBossChallengeConfig:GetCampaignStageConfigById(stageId)
    if self.campaignStageConfig == nil then
        self:InitBossChallengeTowerConfig()
    end
    return self.campaignStageConfig:GetCampaignStageConfigById(stageId)
end

--- @return DefenderTeamData
function EventBossChallengeConfig:GetTotalBossChallengeTower()
    if self.campaignStageConfig == nil then
        self:InitBossChallengeTowerConfig()
    end
    return self.campaignStageConfig:GetTotalTower()
end

function EventBossChallengeConfig:InitBossChallengeTowerLoopConfig()
    local path = string.format("%s/%s", self.path, DEFENDER_TEAM_LOOP)
    local levelDesignContent = CsvReaderUtils.ReadAndParseLocalFile(path)
    require "lua.client.scene.ui.home.uiEventBossChallenge.eventLayout.challenge_tower.BossChallengeTowerConfig"
    self.campaignStageConfig = BossChallengeTowerConfig()
    self.campaignStageConfig:ParseCsv(levelDesignContent)
end

--- @return DefenderTeamData
--- @param stageId number
function EventBossChallengeConfig:GetCampaignStageLoopConfigById(stageId)
    if self.campaignStageConfig == nil then
        self:InitBossChallengeTowerLoopConfig()
    end
    return self.campaignStageConfig:GetCampaignStageConfigById(stageId)
end

--- @return List<ItemIconData>
--- @param stageId number
function EventBossChallengeConfig:GetTowerRewardById(stageId)
    if self.bossChallengeTowerRewardConfig == nil then
        require "lua.client.data.Event.EventBossChallenge.BossChallengeTowerRewardConfig"
        self.bossChallengeTowerRewardConfig = BossChallengeTowerRewardConfig()
    end
    local path = string.format("%s/%s", self.path, BOSS_CHALLENGE_TOWER_REWARD_PATH)
    return self.bossChallengeTowerRewardConfig:GetReward(stageId, path)
end

--- @return List<ItemIconData>
--- @param stageId number
function EventBossChallengeConfig:GetTowerRewardPremiumPassById(stageId)
    if self.bossChallengeTowerPremiumPassRewardConfig == nil then
        require "lua.client.data.Event.EventBossChallenge.BossChallengeTowerRewardConfig"
        self.bossChallengeTowerPremiumPassRewardConfig = BossChallengeTowerRewardConfig()
    end
    local path = string.format("%s/%s", self.path, BOSS_CHALLENGE_TOWER_PREMIUM_REWARD_PATH)
    return self.bossChallengeTowerPremiumPassRewardConfig:GetRewardPremiumPass(stageId, path)
end

--- @return List<ItemIconData>
--- @param stageId number
function EventBossChallengeConfig:GetTowerLoopRewardById(stageId)
    if self.bossChallengeTowerLoopRewardConfig == nil then
        require "lua.client.data.Event.EventBossChallenge.BossChallengeTowerRewardConfig"
        self.bossChallengeTowerLoopRewardConfig = BossChallengeTowerRewardConfig()
    end
    local path = string.format("%s/%s", self.path, BOSS_CHALLENGE_TOWER_LOOP_REWARD_PATH)
    return self.bossChallengeTowerLoopRewardConfig:GetRewardLoop(stageId, path)
end

--- @return List<ItemIconData>
function EventBossChallengeConfig:GetAllTowerLoopRewardById()
    if self.bossChallengeTowerLoopRewardConfig == nil then
        require "lua.client.data.Event.EventBossChallenge.BossChallengeTowerRewardConfig"
        self.bossChallengeTowerLoopRewardConfig = BossChallengeTowerRewardConfig()
    end
    local path = string.format("%s/%s", self.path, BOSS_CHALLENGE_TOWER_LOOP_REWARD_PATH)
    return self.bossChallengeTowerLoopRewardConfig:GetAllRewardLoop(path)
end

--- @return BattleTeamInfo
function EventBossChallengeConfig:GetListLineupRecommendation(id)
    if self.dictLineUpRecommend:Count() == 0 then
        local path = string.format("%s/%s", self.path, DEFENDER_TEAM)
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(path)
        for _, data in pairs(dataParse) do
            if data.stage ~= nil then
                local predefineTeam = PredefineTeamData.CreateByCsv(data)
                ---@type BattleTeamInfo
                local lineupTeam = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(predefineTeam)
                if lineupTeam ~= nil then
                    self.dictLineUpRecommend:Add(tonumber(data.stage), lineupTeam)
                end
            end
        end
    end
    return self.dictLineUpRecommend:Get(id)
end

--- @return BattleTeamInfo
function EventBossChallengeConfig:GetListLineupLoopRecommendation(id)
    if self.dictLineUpLoopRecommend:Count() == 0 then
        local path = string.format("%s/%s", self.path, DEFENDER_TEAM_LOOP)
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(path)
        for _, data in pairs(dataParse) do
            if data.team_id ~= nil then
                local predefineTeam = PredefineTeamData.CreateByCsv(data)
                ---@type BattleTeamInfo
                local lineupTeam = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(predefineTeam)
                if lineupTeam ~= nil then
                    self.dictLineUpLoopRecommend:Add(tonumber(data.team_id), lineupTeam)
                end
            end
        end
    end
    return self.dictLineUpLoopRecommend:Get(id)
end

--- @return Dictionary
--- Get HeroResource from csv corresponding with sel
function EventBossChallengeConfig:GetHeroResourceByDay(id)
    if self.groupHeroDict:Count() == 0 then
        self:InitHeroResource()
    end

    for k,v in pairs(self.groupHeroDict:GetItems()) do
        if k == id then
            local listHero = List()
            for _,v1 in pairs(v:GetItems()) do
                listHero:Add(v1)
            end
            return listHero
        end
    end
    return nil
end

--- @return Dictionary
--- Get HeroResource from csv corresponding with selectionId
function EventBossChallengeConfig:GetHeroResource()
    if self.heroDict:Count() == 0 then
        self:InitHeroResource()
    end
    return self.heroDict
end

function EventBossChallengeConfig:InitHeroResource()
    local path = string.format("%s/%s", self.path, TRIAL_HERO_STAT)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end

    for i = 1, #parsedData do
        local selectId = tonumber(parsedData[i].selection_id);
        if selectId ~= nil then
            local heroId = tonumber(parsedData[i].hero_id);
            local star = tonumber(parsedData[i].star);
            local level = tonumber(parsedData[i].level);
            self.heroDict:Add(selectId, HeroResource.CreateInstance(selectId, heroId, star, level))
        end
    end

    local heroDictTemp = nil

    for _,v in ipairs(parsedData) do
        if v.day ~= nil then
            local dayId = tonumber(v.day)
            ---@type Dictionary
            heroDictTemp = Dictionary()
            self.groupHeroDict:Add(dayId, heroDictTemp)
        end
        
        if v.selection_id ~= nil then
            local heroId = tonumber(v.selection_id)
            local heroIns = self:GetHero(heroId)
            heroDictTemp:Add(heroId, heroIns)
        end
    end
end

--- @return Dictionary
--- @param selectionsId List
--- Get HeroResource from csv corresponding with selectionId
function EventBossChallengeConfig:GetHeroResourceByListSelection(selectionsId)
    if self.groupHeroDict:Count() == 0 then
        self:InitHeroResource()
    end
    --- @type List
    local listHeroResources = List()
    for i = 1, selectionsId:Count() do
        --- @type HeroResource
        local hero = self.heroDict:Get(selectionsId:Get(i))
        hero.inventoryId = selectionsId:Get(i)
        listHeroResources:Add(hero)
    end
    return listHeroResources
end

function EventBossChallengeConfig:GetHero(id)
    local data = self.heroDict:Get(id)
    return data
end
return EventBossChallengeConfig