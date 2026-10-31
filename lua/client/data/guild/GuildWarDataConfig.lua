
local PathGuildWarBattleNonParticipantLoseRewardConfig = "csv/guild/war/battle_reward/guild_war_battle_non_participant_lose_reward.csv"
local PathGuildWarBattleNonParticipantWinRewardConfig = "csv/guild/war/battle_reward/guild_war_battle_non_participant_win_reward.csv"
local PathGuildWarBattleParticipantLoseRewardConfig = "csv/guild/war/battle_reward/guild_war_battle_participant_lose_reward.csv"
local PathGuildWarBattleParticipantWinRewardConfig = "csv/guild/war/battle_reward/guild_war_battle_participant_win_reward.csv"

--- @class GuildWarDataConfig
GuildWarDataConfig = Class(GuildWarDataConfig)

function GuildWarDataConfig:Ctor()
    --- @type GuildWarConfig
    self._guildWarConfig = nil
    --- @type GuildWarListRankingRewardConfig
    self._guildWarSeasonRewardConfig = nil
    --- @type GuildWarListRankingRewardConfig
    self._guildWarBattleNonParticipantLoseRewardConfig = nil
    --- @type GuildWarListRankingRewardConfig
    self._guildWarBattleNonParticipantWinRewardConfig = nil
    --- @type GuildWarListRankingRewardConfig
    self._guildWarBattleParticipantLoseRewardConfig = nil
    --- @type GuildWarListRankingRewardConfig
    self._guildWarBattleParticipantWinRewardConfig = nil
    --- @type GuildWarEloPositionConfig
    self._guildWarEloPositionConfig = nil
end

--- @return GuildWarConfig
function GuildWarDataConfig:GetGuildWarConfig()
    if self._guildWarConfig == nil then
        require "lua.client.data.Guild.GuildWar.GuildWarConfig"
        self._guildWarConfig = GuildWarConfig()
    end
    return self._guildWarConfig
end

--- @return GuildWarEloPositionConfig
function GuildWarDataConfig:GetGuildWarEloPositionConfig()
    if self._guildWarEloPositionConfig == nil then
        require "lua.client.data.Guild.GuildWar.GuildWarEloPositionConfig"
        self._guildWarEloPositionConfig = GuildWarEloPositionConfig()
    end
    return self._guildWarEloPositionConfig
end

--- @return GuildWarListRankingRewardConfig
function GuildWarDataConfig:GetGuildWarSeasonRewardConfig()
    if self._guildWarSeasonRewardConfig == nil then
        require "lua.client.data.Guild.GuildWar.GuildWarListRankingRewardConfig"
        self._guildWarSeasonRewardConfig = GuildWarListRankingRewardConfig(CsvPathConstants.GUILD_WAR_SEASON_REWARD_CONFIG)
    end
    return self._guildWarSeasonRewardConfig
end

--- @return GuildWarListRankingRewardConfig
function GuildWarDataConfig:GetGuildWarBattleRewardConfig(isParticipant, isWin)
    if not isParticipant and not isWin then
        if self._guildWarBattleNonParticipantLoseRewardConfig == nil then
            require "lua.client.data.Guild.GuildWar.GuildWarListRankingRewardConfig"
            self._guildWarBattleNonParticipantLoseRewardConfig = GuildWarListRankingRewardConfig(PathGuildWarBattleNonParticipantLoseRewardConfig)
        end
        return self._guildWarBattleNonParticipantLoseRewardConfig
    elseif not isParticipant and isWin then
        if self._guildWarBattleNonParticipantWinRewardConfig == nil then
            require "lua.client.data.Guild.GuildWar.GuildWarListRankingRewardConfig"
            self._guildWarBattleNonParticipantWinRewardConfig = GuildWarListRankingRewardConfig(PathGuildWarBattleNonParticipantWinRewardConfig)
        end
        return self._guildWarBattleNonParticipantWinRewardConfig
    elseif isParticipant and not isWin then
        if self._guildWarBattleParticipantLoseRewardConfig == nil then
            require "lua.client.data.Guild.GuildWar.GuildWarListRankingRewardConfig"
            self._guildWarBattleParticipantLoseRewardConfig = GuildWarListRankingRewardConfig(PathGuildWarBattleParticipantLoseRewardConfig)
        end
        return self._guildWarBattleParticipantLoseRewardConfig
    elseif isParticipant and isWin then
        if self._guildWarBattleParticipantWinRewardConfig == nil then
            require "lua.client.data.Guild.GuildWar.GuildWarListRankingRewardConfig"
            self._guildWarBattleParticipantWinRewardConfig = GuildWarListRankingRewardConfig(PathGuildWarBattleParticipantWinRewardConfig)
        end
        return self._guildWarBattleParticipantWinRewardConfig
    end
end