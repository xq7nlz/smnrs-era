require "lua.client.data.Guild.Dungeon.GuildDungeonStageRewardConfig"
require "lua.client.data.Guild.Dungeon.GuildDungeonTeamConfig"
require "lua.client.data.Guild.RankingRewardByRangeConfig"

--- @class GuildDungeonConfig
GuildDungeonConfig = Class(GuildDungeonConfig)

function GuildDungeonConfig:Ctor()
    --- @type {guild_coin_per_join, max_guild_dungeon_stamina, guild_dungeon_stamina_per_day}
    self._generalGuildDungeonConfig = nil

    --- @type List --- {RankingRewardByRangeConfig}
    self._dungeonSeasonReward = nil

    --- @type GuildDungeonStageRewardConfig
    self._guildDungeonStageRewardConfig = nil
    --- @type GuildDungeonTeamConfig
    self._dungeonTeamConfig = nil
    --- @type RewardInBound
    self._joinReward = nil

    self:_InitGeneralConfig()
    self:_InitSeasonReward()
end

function GuildDungeonConfig:_InitGeneralConfig()
    --- @type {guild_coin_per_join, max_guild_dungeon_stamina, guild_dungeon_stamina_per_day}
    self._generalGuildDungeonConfig = {}

    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_DUNGEON_CONFIG_PATH)

    self._generalGuildDungeonConfig.guild_coin_per_join = tonumber(parsedData[1].guild_coin_per_join)
    self._generalGuildDungeonConfig.max_guild_dungeon_stamina = tonumber(parsedData[1].max_guild_dungeon_stamina)
    self._generalGuildDungeonConfig.guild_dungeon_stamina_per_day = tonumber(parsedData[1].guild_dungeon_stamina_per_day)
end

function GuildDungeonConfig:_InitSeasonReward()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_DUNGEON_SEASON_REWARD_PATH)
    local currentIndexListSub
    self._dungeonSeasonReward = List()
    for i = 1, #parsedData do
        local min_rank = tonumber(parsedData[i].min_ranking)
        local max_rank = tonumber(parsedData[i].max_ranking)
        --- @type RankingRewardByRangeConfig
        local currentRankingRewardByRangeConfig
        if MathUtils.IsNumber(min_rank) == true and MathUtils.IsNumber(max_rank) == true then
            currentRankingRewardByRangeConfig = RankingRewardByRangeConfig(min_rank, max_rank)
            self._dungeonSeasonReward:Add(currentRankingRewardByRangeConfig)
            if i == 1 then
                currentIndexListSub = 1
            else
                currentIndexListSub = currentIndexListSub + 1
            end
        else
            currentRankingRewardByRangeConfig = self._dungeonSeasonReward:Get(currentIndexListSub)
        end
        local data = parsedData[i]
        currentRankingRewardByRangeConfig:AddRewardToList(RewardInBound.CreateByParams(data))
    end
end

--- @return {guild_coin_per_join, max_guild_dungeon_stamina, guild_dungeon_stamina_per_day}
function GuildDungeonConfig:GetGeneralGuildDungeonConfig()
    return self._generalGuildDungeonConfig
end

--- @return RewardInBound
function GuildDungeonConfig:GetWinStageReward()
    local rewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GUILD_BASIC_COIN,
            self:GetGeneralGuildDungeonConfig().guild_coin_per_join, nil)
    return rewardInBound
end

--- @return List
function GuildDungeonConfig:GetSeasonRewardConfig()
    return self._dungeonSeasonReward
end

--- @return RankingRewardByRangeConfig
--- @param rank number
function GuildDungeonConfig:GetSeasonRewardConfigByRank(rank)
    for i = 1, self._dungeonSeasonReward:Count() do
        local rankingRewardByRangeConfig = self._dungeonSeasonReward:Get(i)
        if rankingRewardByRangeConfig.min_rank >= rank and rankingRewardByRangeConfig.max_rank <= rank then
            return rankingRewardByRangeConfig
        end
    end
    return self._dungeonSeasonReward:Get(self._dungeonSeasonReward:Count())
end

--- @return GuildDungeonStageRewardConfig
function GuildDungeonConfig:GetDungeonStageRewardConfig()
    if self._guildDungeonStageRewardConfig == nil then
        self._guildDungeonStageRewardConfig = GuildDungeonStageRewardConfig()
    end
    return self._guildDungeonStageRewardConfig
end

--- @return GuildDungeonStageRewardConfig
function GuildDungeonConfig:GetDungeonStageRewardConfig()
    if self._guildDungeonStageRewardConfig == nil then
        self._guildDungeonStageRewardConfig = GuildDungeonStageRewardConfig()
    end
    return self._guildDungeonStageRewardConfig
end

--- @return GuildDungeonTeamConfig
function GuildDungeonConfig:GetGuildDungeonTeamConfig()
    if self._dungeonTeamConfig == nil then
        self._dungeonTeamConfig = GuildDungeonTeamConfig()
    end
    return self._dungeonTeamConfig
end

--- @return RewardInBound
function GuildDungeonConfig:GetJoinReward()
    if self._joinReward == nil then
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_DUNGEON_JOIN_REWARD_PATH)
        self._joinReward = RewardInBound.CreateByParams(parsedData[1])
    end
    return self._joinReward
end

return GuildDungeonConfig