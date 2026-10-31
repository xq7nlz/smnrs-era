require "lua.client.core.network.playerData.PlayerDataMethod"
require "lua.client.core.network.friend.BossStatisticsInBound"
require "lua.client.core.network.chat.ChatRequest"
require "lua.client.data.Quest.QuestElementConfig"
require "lua.client.core.network.playerData.SeedInBound"

local methodDict = Dictionary()
--- @return void
local function InitPlayerData()
    require "lua.client.core.network.playerData.BasicInfoInBound"
    methodDict:Add(PlayerDataMethod.BASIC_INFO, BasicInfoInBound)
    require "lua.client.core.network.playerData.HeroCollectionInBound"
    methodDict:Add(PlayerDataMethod.HERO_COLLECTION, HeroCollectionInBound)
    require "lua.client.core.network.playerData.ItemCollectionInBound"
    methodDict:Add(PlayerDataMethod.ITEM_COLLECTION, ItemCollectionInBound)
    require "lua.client.core.network.playerData.CampaignInBound"
    methodDict:Add(PlayerDataMethod.CAMPAIGN, CampaignInBound)
    require "lua.client.core.network.playerData.dungeon.DungeonInBound"
    methodDict:Add(PlayerDataMethod.DUNGEON, DungeonInBound)
    require "lua.client.core.network.tutorial.TutorialInBound"
    methodDict:Add(PlayerDataMethod.TUTORIAL, TutorialInBound)
    require "lua.client.core.network.playerData.RaidInBound"
    methodDict:Add(PlayerDataMethod.RAID, RaidInBound)
    require "lua.client.core.network.playerData.TowerInBound"
    methodDict:Add(PlayerDataMethod.TOWER, TowerInBound)
    require "lua.client.core.network.playerData.common.ModeShopDataInBound"
    methodDict:Add(PlayerDataMethod.MARKET, ModeShopDataInBound)
    methodDict:Add(PlayerDataMethod.ALTAR_MARKET, ModeShopDataInBound)
    methodDict:Add(PlayerDataMethod.GUILD_MARKET, ModeShopDataInBound)
    methodDict:Add(PlayerDataMethod.ARENA_MARKET, ModeShopDataInBound)
    methodDict:Add(PlayerDataMethod.ARENA_TEAM_MARKET, ModeShopDataInBound)
    require "lua.client.core.network.playerData.mastery.PlayerMasteryInBound"
    methodDict:Add(PlayerDataMethod.MASTERY, PlayerMasteryInBound)
    require "lua.client.core.network.playerData.playerServerList.PlayerServerListInBound"
    methodDict:Add(PlayerDataMethod.SERVER_LIST, PlayerServerListInBound)
    require "lua.client.core.network.playerData.summoner.PlayerSummonerInBound"
    methodDict:Add(PlayerDataMethod.SUMMONER, PlayerSummonerInBound)
    require "lua.client.core.network.playerData.summon.HeroSummonInBound"
    methodDict:Add(PlayerDataMethod.SUMMON, HeroSummonInBound)
    require "lua.client.core.network.playerData.casino.PlayerCasinoInBound"
    methodDict:Add(PlayerDataMethod.CASINO, PlayerCasinoInBound)
    require "lua.client.core.network.playerData.tavern.PlayerTavernDataInBound"
    methodDict:Add(PlayerDataMethod.TAVERN, PlayerTavernDataInBound)
    require "lua.client.core.network.playerData.dailyData.PlayerDailyDataInBound"
    methodDict:Add(PlayerDataMethod.DAILY_REWARD, PlayerDailyDataInBound)
    require "lua.client.core.network.playerData.HeroFragmentInBound"
    methodDict:Add(PlayerDataMethod.HERO_FRAGMENT_COLLECTION, HeroFragmentInBound)
    require "lua.client.core.network.campaign.CampaignRankingInBound"
    methodDict:Add(PlayerDataMethod.CAMPAIGN_RANKING, CampaignRankingInBound)
    require "lua.client.core.network.tower.TowerRankingInBound"
    methodDict:Add(PlayerDataMethod.TOWER_RANKING, TowerRankingInBound)
    require "lua.client.core.network.dungeon.DungeonRankingInBound"
    methodDict:Add(PlayerDataMethod.DUNGEON_RANKING, DungeonRankingInBound)
    require "lua.client.core.network.friend.FriendRankingInBound"
    methodDict:Add(PlayerDataMethod.FRIEND_RANKING, FriendRankingInBound)
    require "lua.client.core.network.playerData.friend.PlayerFriendInBound"
    methodDict:Add(PlayerDataMethod.FRIEND, PlayerFriendInBound)
    require "lua.client.core.network.playerData.arena.ArenaDataInBound"
    methodDict:Add(PlayerDataMethod.ARENA, ArenaDataInBound)
    require "lua.client.core.network.playerData.arena.GroupArenaRankingInBound"
    methodDict:Add(PlayerDataMethod.ARENA_GROUP_RANKING, GroupArenaRankingInBound)
    require "lua.client.core.network.playerData.arena.ServerArenaRankingInBound"
    methodDict:Add(PlayerDataMethod.ARENA_SERVER_RANKING, ServerArenaRankingInBound)
    require "lua.client.core.network.playerData.chat.ChatWorldInBound"
    methodDict:Add(PlayerDataMethod.CHAT_WORLD, ChatWorldInBound)
    require "lua.client.core.network.playerData.chat.ChatGuildInBound"
    methodDict:Add(PlayerDataMethod.CHAT_GUILD, ChatGuildInBound)
    require "lua.client.core.network.playerData.chat.ChatRecruitInBound"
    methodDict:Add(PlayerDataMethod.CHAT_RECRUIT, ChatRecruitInBound)
    require "lua.client.core.network.playerData.chat.ChatSystemInBound"
    methodDict:Add(PlayerDataMethod.CHAT_SYSTEM, ChatSystemInBound)
    require "lua.client.core.network.playerData.chat.ChatDomainCrewInBound"
    methodDict:Add(PlayerDataMethod.DOMAINS_CHAT_CREW, ChatDomainCrewInBound)
    require "lua.client.core.network.playerData.chat.ChatDomainRecruitInBound"
    methodDict:Add(PlayerDataMethod.DOMAINS_CHAT_RECRUIT, ChatDomainRecruitInBound)
    require "lua.client.core.network.campaign.CampaignDetailTeamFormationInBound"
    methodDict:Add(PlayerDataMethod.CAMPAIGN_DETAIL_FORMATION, CampaignDetailTeamFormationInBound)
    require "lua.client.core.network.playerData.mail.MailDataInBound"
    methodDict:Add(PlayerDataMethod.MAIL, MailDataInBound)
    require "lua.client.core.network.playerData.heroFood.PlayerHeroFoodInBound"
    methodDict:Add(PlayerDataMethod.HERO_EVOLVE_FOOD, PlayerHeroFoodInBound)
    require "lua.client.core.network.event.EventInBound"
    methodDict:Add(PlayerDataMethod.EVENT_TIME, EventInBound)
    require "lua.client.core.network.playerData.common.QuestDataInBound"
    methodDict:Add(PlayerDataMethod.QUEST, QuestDataInBound)
    require "lua.client.core.network.guild.GuildBasicInfoInBound"
    methodDict:Add(PlayerDataMethod.GUILD_BASIC_INFO, GuildBasicInfoInBound)
    require "lua.client.core.network.guild.GuildApplicationInBound"
    methodDict:Add(PlayerDataMethod.GUILD_APPLICATION, GuildApplicationInBound)
    require "lua.client.core.network.guild.GuildBossDataInBound"
    methodDict:Add(PlayerDataMethod.GUILD_BOSS, GuildBossDataInBound)
    require "lua.client.core.network.guild.GuildDungeonInBound"
    methodDict:Add(PlayerDataMethod.GUILD_DUNGEON, GuildDungeonInBound)
    require "lua.client.core.network.guild.GuildLogDataInBound"
    methodDict:Add(PlayerDataMethod.GUILD_LOG, GuildLogDataInBound)
    require "lua.client.core.network.playerData.HandOfMidasInBound"
    methodDict:Add(PlayerDataMethod.HAND_OF_MIDAS, HandOfMidasInBound)
    require "lua.client.core.network.playerData.BlockPlayerInBound"
    methodDict:Add(PlayerDataMethod.BLOCKED_PLAYER_LIST, BlockPlayerInBound)
    require "lua.client.core.network.guild.GuildDungeonRankingDataInBound"
    methodDict:Add(PlayerDataMethod.GUILD_DUNGEON_RANKING, GuildDungeonRankingDataInBound)
    methodDict:Add(PlayerDataMethod.GUILD_DUNGEON_HALL_OF_FAME, GuildDungeonHallOfFameRankingDataInBound)
    require "lua.client.core.network.iap.IapDataInBound"
    methodDict:Add(PlayerDataMethod.IAP, IapDataInBound)
    require "lua.client.core.network.playerData.StatisticsInBound"
    methodDict:Add(PlayerDataMethod.STATISTICS, StatisticsInBound)
    require "lua.client.core.network.videoRewarded.VideoRewardedInBound"
    methodDict:Add(PlayerDataMethod.REWARD_VIDEO, VideoRewardedInBound)
    require "lua.client.core.network.playerData.chat.ChatCreatedTimeInBound"
    methodDict:Add(PlayerDataMethod.CHAT_CREATED_TIME, ChatCreatedTimeInBound)
    require "lua.client.core.network.temple.ProphetTreeInBound"
    methodDict:Add(PlayerDataMethod.PROPHET_TREE, ProphetTreeInBound)
    require "lua.client.core.network.guild.guildWar.GuildWarInBound"
    methodDict:Add(PlayerDataMethod.GUILD_WAR, GuildWarInBound)
    require "lua.client.core.network.guild.guildWar.GuildWarTimeInBound"
    methodDict:Add(PlayerDataMethod.GUILD_WAR_TIME, GuildWarTimeInBound)
    require "lua.client.core.network.guild.guildWar.GuildWarRankingInBound"
    methodDict:Add(PlayerDataMethod.GUILD_WAR_RANKING, GuildWarRankingInBound)
    require "lua.client.core.network.playerData.Authentication.AuthenticationInBound"
    methodDict:Add(PlayerDataMethod.AUTHENTICATION, AuthenticationInBound)
    require "lua.client.core.network.playerData.defenseMode.DefenseModeInbound"
    methodDict:Add(PlayerDataMethod.DEFENSE_MODE, DefenseModeInbound)
    require "lua.client.core.network.playerData.raiseLevel.PlayerRaiseLevelInbound"
    methodDict:Add(PlayerDataMethod.RAISE_HERO, PlayerRaiseLevelInbound)
    require "lua.client.core.network.playerData.heroLinking.HeroLinkingInBound"
    methodDict:Add(PlayerDataMethod.HERO_LINKING, HeroLinkingInBound)
    require "lua.client.core.network.playerData.FeatureConfigInBound"
    methodDict:Add(PlayerDataMethod.FEATURE_CONFIG, FeatureConfigInBound)
    require "lua.client.core.network.playerData.arenaTeam.ArenaTeamInBound"
    methodDict:Add(PlayerDataMethod.ARENA_TEAM, ArenaTeamInBound)
    require "lua.client.core.network.playerData.WelcomeBack.WelcomeBackInBound"
    methodDict:Add(PlayerDataMethod.COMEBACK, WelcomeBackInBound)
    require "lua.client.core.network.playerData.domain.DomainInBound"
    methodDict:Add(PlayerDataMethod.DOMAIN, DomainInBound)
    require "lua.client.core.network.playerData.serverOpen.ServerOpenInBound"
    methodDict:Add(PlayerDataMethod.SERVER_OPEN, ServerOpenInBound)
end

InitPlayerData()

local function GetBitmaskDataOutBound(...)
    local args = { ... }
    local bitmask1 = 0
    local bitmask2 = 0
    for i = 1, #args do
        if args[i] < 64 then
            bitmask1 = BitUtils.TurnOn(bitmask1, args[i])
        else
            bitmask2 = BitUtils.TurnOn(bitmask2, args[i] - 64)
        end
    end
    return bitmask1, bitmask2
end

--- @param buffer UnifiedNetwork_ByteBuf
local function OnBufferReading(buffer)
    local bitmaskInBound = buffer:GetLong()
    local bitmaskInBound2 = buffer:GetLong()
    for bitCount = 0, 127 do
        if (bitCount < 64 and BitUtils.IsOn(bitmaskInBound, bitCount))
                or (bitCount >= 64 and bitCount < 128 and BitUtils.IsOn(bitmaskInBound2, bitCount - 64)) then
            local functionCheck = function(buffer)
                local inBound = zg.playerData:GetMethod(bitCount)
                if inBound == nil then
                    inBound = zg.playerData:AddMethod(bitCount)
                end
                inBound:ReadBuffer(buffer)
            end
            if NetworkUtils.CheckMaskRequest(buffer, functionCheck) == false then
                XDebug.Log("player_data error bitmask: " .. tostring(bitCount))
            end
        end
    end
end

--- @return void
local function RequestBitMask(bitmask1, bitmask2, onSuccess, onFailed, showWaiting)
    local onReceived = function(result)
        NetworkUtils.ExecuteResult(result, OnBufferReading, onSuccess, onFailed)
    end

    NetworkUtils.Request(OpCode.PLAYER_DATA_GET, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask1, PutMethod.Long, bitmask2), onReceived, showWaiting)
end

--- @class PlayerDataRequest
PlayerDataRequest = {}

--- @return void
function PlayerDataRequest.Request(...)
    local bitmask1 ,bitmask2 = GetBitmaskDataOutBound(...)
    RequestBitMask(bitmask1 ,bitmask2)
end

--- @return void
function PlayerDataRequest.RequestAndCallback(data, onSuccess, onFailed, showWaiting)
    local bitmask1 ,bitmask2  = BitUtils.GetNumberByBitIndexTable(data)
    RequestBitMask(bitmask1, bitmask2, onSuccess, onFailed, showWaiting)
end

function PlayerDataRequest.GetMethod(method)
    local inbound = methodDict:Get(method)
    if inbound == nil then
        XDebug.Error(string.format("Method is not exist: %s", tostring(method)))
    end
    return inbound()
end

--- @return void
--- @param onRequestSuccess function
--- @param onRequestFailed function
function PlayerDataRequest.RequestAllData(onRequestSuccess, onRequestFailed, showWaiting)
    local data = {
        PlayerDataMethod.TUTORIAL,
        PlayerDataMethod.FRIEND,
        PlayerDataMethod.HERO_EVOLVE_FOOD,
        PlayerDataMethod.HAND_OF_MIDAS,
        PlayerDataMethod.BASIC_INFO,
        PlayerDataMethod.MASTERY,
        PlayerDataMethod.HERO_FRAGMENT_COLLECTION,
        PlayerDataMethod.SUMMONER,
        PlayerDataMethod.HERO_COLLECTION,
        PlayerDataMethod.ITEM_COLLECTION,
        PlayerDataMethod.DUNGEON,
        PlayerDataMethod.SERVER_LIST,
        PlayerDataMethod.SUMMON,
        PlayerDataMethod.DAILY_REWARD,
        PlayerDataMethod.CAMPAIGN,
        PlayerDataMethod.RAID,
        PlayerDataMethod.TOWER,
        PlayerDataMethod.TAVERN,
        PlayerDataMethod.MAIL,
        PlayerDataMethod.BLOCKED_PLAYER_LIST,
        PlayerDataMethod.CHAT_CREATED_TIME,
        PlayerDataMethod.QUEST,
        PlayerDataMethod.GUILD_BASIC_INFO,
        PlayerDataMethod.GUILD_WAR_TIME,
        PlayerDataMethod.IAP,
        PlayerDataMethod.REWARD_VIDEO,
        PlayerDataMethod.PROPHET_TREE,
        PlayerDataMethod.AUTHENTICATION,
        PlayerDataMethod.EVENT_TIME,
        PlayerDataMethod.CHAT_SYSTEM,
        PlayerDataMethod.MARKET,
        PlayerDataMethod.ARENA_MARKET,
        PlayerDataMethod.DEFENSE_MODE,
        PlayerDataMethod.GUILD_MARKET,
        PlayerDataMethod.RAISE_HERO,
        PlayerDataMethod.HERO_LINKING,
        PlayerDataMethod.FEATURE_CONFIG,
        PlayerDataMethod.ARENA,
        PlayerDataMethod.ARENA_TEAM,
        PlayerDataMethod.ARENA_TEAM_MARKET,
        PlayerDataMethod.COMEBACK,
        PlayerDataMethod.DOMAIN,
        PlayerDataMethod.SERVER_OPEN,
    }
    local bitmask1, bitmask2  = BitUtils.GetNumberByBitIndexTable(data)
    local requestPlayerData = Job(function(success, fail)
        NetworkUtils.Request(OpCode.PLAYER_DATA_GET, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask1, PutMethod.Long, bitmask2), function(result)
            InventoryUtils.Clear()
            zg.timeMgr:RemoveAllUpdateFunction()
            PlayerData.ClearAllData()
            ChatRequest.UnsubscribeChat()

            PlayerData.UpdateABTestValue()
            NetworkUtils.ExecuteResult(result, OnBufferReading, success, fail)

        end, showWaiting)
    end)
    local requestRemoteConfig = Job(function(success, fail)
        require "lua.client.core.network.remoteConfig.RemoteConfigSetOutbound"
        RemoteConfigSetOutBound.GetValueByKey(REMOTE_CONFIG_KEY, function(data)
            success(json.decode(data))
        end, function()
            success({})
        end)
    end)
    local validateServerList = Job(function(success, onFailed)
        ServerListInBound.Validate(success, true)
    end)

    ---@type Job
    local job = requestPlayerData + requestRemoteConfig + validateServerList
    job:Complete(function()
        zg.playerData.remoteConfig = requestRemoteConfig.data
        if onRequestSuccess ~= nil then
            onRequestSuccess()
        end
    end, onRequestFailed)
end

function PlayerDataRequest.RequestAllResources(onRequestSuccess, onRequestFailed, showWaiting)
    local data = { PlayerDataMethod.ITEM_COLLECTION, PlayerDataMethod.BASIC_INFO }
    local bitmask1, bitmask2 = BitUtils.GetNumberByBitIndexTable(data)
    NetworkUtils.Request(OpCode.PLAYER_DATA_GET, UnknownOutBound.CreateInstance(PutMethod.Long, bitmask1, PutMethod.Long, bitmask2), function(result)
        NetworkUtils.ExecuteResult(result, OnBufferReading, onRequestSuccess, onRequestFailed)
    end, showWaiting)
end
