require "lua.client.data.Event.BossChallengeRewardMilestoneData"
require "lua.client.data.Event.EventNewHero.BossChallenge.RankingRewardConfig"

local BOSS_CHALLENGE_CONFIG = "boss_challenge_config.csv"
local DEFENDER_TEAM_PATH = "defender_team.csv"
local REWARD_CONFIG_PATH = "reward_config.csv"
local RANKING_REWARD_PATH = "leader_board_reward.csv"

--- @class EventNewHeroBossChallengeConfig
EventNewHeroBossChallengeConfig = Class(EventNewHeroBossChallengeConfig)

function EventNewHeroBossChallengeConfig:Ctor(path)
    self.path = path
    --- @type number
    self.numberRewardPerDay = nil
    --- @type number
    self.blockDuration = nil

    --- @type DefenderTeamData
    self.defender = nil

    --- @type List
    self.listBossDamageRewardConfig = nil

    --- @type List
    self.listRankingReward = nil

    self:GetBossChallengeConfig()
end

--- @return Dictionary
function EventNewHeroBossChallengeConfig:GetBossChallengeConfig()
    local path = string.format("%s/%s", self.path, BOSS_CHALLENGE_CONFIG)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    self.numberRewardPerDay = tonumber(parsedData[1].number_reward_per_day)
    self.blockDuration = tonumber(parsedData[1].block_duration)
end

--- @return List
function EventNewHeroBossChallengeConfig:GetBossChallengeRewardList()
    if self.listBossDamageRewardConfig == nil then
        local path = string.format("%s/%s", self.path, REWARD_CONFIG_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        self.listBossDamageRewardConfig = List()
        --- @type BossChallengeRewardMilestoneData
        local milestoneConfig
        for i = 1, #parsedData do
            local data = parsedData[i]
            if data.milestone_damage ~= nil then
                milestoneConfig = BossChallengeRewardMilestoneData()
                milestoneConfig:ParsedData(data)
                self.listBossDamageRewardConfig:Add(milestoneConfig)
            else
                milestoneConfig:AddData(data)
            end
        end
    end
    return self.listBossDamageRewardConfig
end

--- @return Dictionary
function EventNewHeroBossChallengeConfig:GetRoseCost()
    if self.roseCost == nil then
        local path = string.format("%s/%s", self.path, REWARD_CONFIG_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Get EventConfig nil %s", path))
            return
        end

        self.roseCost = tonumber(parsedData[1].gem_price)
    end

    return self.roseCost
end

--- @return DefenderTeamData
function EventNewHeroBossChallengeConfig:GetDefenderTeam()
    if self.defender == nil then
        local path = string.format("%s/%s", self.path, DEFENDER_TEAM_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Get EventConfig nil %s", path))
            return
        end
        self.defender = DefenderTeamData(parsedData[1])
    end
    return self.defender
end

--- @return List
function EventNewHeroBossChallengeConfig:GetListRewardRanking(rank)
    --- @type RankingRewardConfig
    local ranking = nil
    if self.listRankingReward == nil then
        local path = string.format("%s/%s", self.path, RANKING_REWARD_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Get EventConfig nil %s", path))
            return
        end
        self.listRankingReward = List()
        for i = 1, #parsedData do
            local data = parsedData[i]
            if data.min ~= nil then
                ranking = RankingRewardConfig()
                ranking:ParsedData(data)
                self.listRankingReward:Add(ranking)
            else
                ranking:AddData(data)
            end
        end
    end
    ranking = nil
    ---@param v RankingRewardConfig
    for i, v in ipairs(self.listRankingReward:GetItems()) do
        if (v.min <=rank and v.max >= rank) then
            ranking = v
            break
        end
    end
    if ranking ~= nil then
        return ranking.listReward
    else
        return nil
    end
end