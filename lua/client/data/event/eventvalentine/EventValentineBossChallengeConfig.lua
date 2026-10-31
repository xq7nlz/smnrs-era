require "lua.client.data.Event.BossChallengeRewardMilestoneData"

local BOSS_CHALLENGE_CONFIG = "boss/challenge_config.csv"
local BOSS_REWARD_CONFIG = "boss/reward_config.csv"
local BOSS_STAMINA_CONFIG = "boss/stamina_config.csv"
local BOSS_DEFENDER_TEAM_CONFIG = "boss/defender_team.csv"

--- @class EventValentineBossChallengeConfig
EventValentineBossChallengeConfig = Class(EventValentineBossChallengeConfig)

--- @param path string
function EventValentineBossChallengeConfig:Ctor(path)
    self.path = path

    --- @type number
    self.blockDuration = nil
    --- @type List
    self.challengePriceList = nil

    --- @type List
    self.listBossDamageRewardConfig = nil

    --- @type number
    self.defaultStamina = nil
    --- @type number
    self.maxNumberBuy = nil
    --- @type RewardInBound
    self.staminaPrice = nil

    self:GetChallengeConfig()

    self:GetRewardConfig()

    self:GetStaminaConfig()
end

function EventValentineBossChallengeConfig:GetChallengeConfig()
    local path = string.format("%s/%s", self.path, BOSS_CHALLENGE_CONFIG)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    self.blockDuration = tonumber(parsedData[1].block_duration)
    self.challengePriceList = List()
    for i = 1, #parsedData do
        local moneyType = tonumber(parsedData[i].money_type)
        local moneyValue = tonumber(parsedData[i].money_value)
        self.challengePriceList:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, moneyType, moneyValue))
    end
end

function EventValentineBossChallengeConfig:GetRewardConfig()
    local path = string.format("%s/%s", self.path, BOSS_REWARD_CONFIG)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    self.listBossDamageRewardConfig = List()
    --- @type BossChallengeRewardMilestoneData
    local milestoneConfig = nil
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

function EventValentineBossChallengeConfig:GetStaminaConfig()
    local path = string.format("%s/%s", self.path, BOSS_STAMINA_CONFIG)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)

    local staminaPriceType = tonumber(parsedData[1].money_type)
    local staminaPriceValue = tonumber(parsedData[1].money_value)
    self.staminaPrice = RewardInBound.CreateBySingleParam(ResourceType.Money, staminaPriceType, staminaPriceValue)
    self.maxNumberBuy = tonumber(parsedData[1].max_number_buy)
    self.defaultStamina = tonumber(parsedData[1].number_stamina_default)
end

--- @return DefenderTeamData
function EventValentineBossChallengeConfig:GetDefenderTeamData()
    if self.bossDefenderTeamData == nil then
        require "lua.client.data.DefenderTeamData"
        local path = string.format("%s/%s", self.path, BOSS_DEFENDER_TEAM_CONFIG)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        --- @type DefenderTeamData
        self.bossDefenderTeamData = DefenderTeamData(parsedData[1])
    end
    return self.bossDefenderTeamData
end