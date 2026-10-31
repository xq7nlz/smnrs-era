require "lua.client.data.Event.BossChallengeRewardMilestoneData"

local BOSS_CHALLENGE_CONFIG = "challenge_config.csv"
local BOSS_REWARD_CONFIG = "reward_config.csv"
local BOSS_STAMINA_CONFIG = "stamina_config.csv"
local BOSS_DEFENDER_TEAM_CONFIG = "defender_team.csv"
local LEADER_BOSS_CONFIG = "leader_board_reward.csv"
local HERO_BOSS_CONFIG = "event_hero.csv"

--- @class EventFindeBossChallengeConfig
EventFindeBossChallengeConfig = Class(EventFindeBossChallengeConfig)

--- @param path string
function EventFindeBossChallengeConfig:Ctor(path)
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

    --- @type number
    self.heroId = nil

    self:GetChallengeConfig()

    self:GetRewardConfig()

    self:GetStaminaConfig()
end

function EventFindeBossChallengeConfig:GetChallengeConfig()
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

function EventFindeBossChallengeConfig:GetRewardConfig()
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

function EventFindeBossChallengeConfig:GetListRewardByRank(rank)
    self:GetArenaConfigList()
    for i = self.arenaConfigList:Count(), 1, -1 do
        ---@type ArenaRewardRankingConfig
        local arenaRewardRankingConfig = self.arenaConfigList:Get(i)
        if (rank >= arenaRewardRankingConfig.topMin) then
            return arenaRewardRankingConfig.listRewardItem
        end
    end

end

function EventFindeBossChallengeConfig:GetStaminaConfig()
    local path = string.format("%s/%s", self.path, BOSS_STAMINA_CONFIG)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)

    local staminaPriceType = tonumber(parsedData[1].money_type)
    local staminaPriceValue = tonumber(parsedData[1].money_value)
    self.staminaPrice = RewardInBound.CreateBySingleParam(ResourceType.Money, staminaPriceType, staminaPriceValue)
    self.maxNumberBuy = tonumber(parsedData[1].max_number_buy)
    self.defaultStamina = tonumber(parsedData[1].number_stamina_default)
end

--- @return DefenderTeamData
function EventFindeBossChallengeConfig:GetDefenderTeamData()
    if self.bossDefenderTeamData == nil then
        require "lua.client.data.DefenderTeamData"
        local path = string.format("%s/%s", self.path, BOSS_DEFENDER_TEAM_CONFIG)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        --- @type DefenderTeamData
        self.bossDefenderTeamData = DefenderTeamData(parsedData[1])
    end
    return self.bossDefenderTeamData
end

--- @return List
function EventFindeBossChallengeConfig:GetArenaConfigList()
    if self.arenaConfigList == nil then
        self.arenaConfigList = List()
        local path = string.format("%s/%s", self.path, LEADER_BOSS_CONFIG)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        local topMin = nil
        local topMax = nil
        local listResourceItems = List()
        ---@type ArenaRewardRankingConfig
        local arenaRewardRankingConfig
        for i = 1, #parsedData do
            local lineData = parsedData[i]
            if lineData["min"] ~= nil then
                require "lua.client.data.Arena.ArenaRewardRankingConfig"
                ---@type ArenaRewardRankingConfig
                arenaRewardRankingConfig = ArenaRewardRankingConfig()
                self.arenaConfigList:Add(arenaRewardRankingConfig)
                arenaRewardRankingConfig.topMin  = tonumber(lineData["min"])
                arenaRewardRankingConfig.topMax  = tonumber(lineData["max"])
                arenaRewardRankingConfig.listRewardItem = List()
            else

            end
            ---@type ItemIconData
            local itemIconData = ItemIconData.CreateInstance(tonumber(lineData["res_type"]), tonumber(lineData["res_id"]), tonumber(lineData["res_number"]))
            arenaRewardRankingConfig.listRewardItem:Add(itemIconData)
        end
    end
    return self.arenaConfigList
end

--- @return List
function EventFindeBossChallengeConfig:GetBossHeroId()
    local path = string.format("%s/%s", self.path, HERO_BOSS_CONFIG)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format(" nil %s", HERO_BOSS_CONFIG))
        return
    end
    if self.heroId == nil then
        for i = 1, #parsedData do
            if parsedData[i].hero_id ~= nil then
                self.heroId = tonumber(parsedData[i].hero_id)
            end
        end
    end
    return self.heroId
end