local EVENT_SUMMON_PATH = "csv/event/event_summon/data_%d/summon_quest.csv"
local EVENT_ARENA_PATH = "csv/event/event_arena/data_%d/arena_quest.csv"
local EVENT_TAVERN_PATH = "csv/event/event_tavern/data_%d/tavern_quest.csv"
local EVENT_CASINO_PATH = "csv/event/event_casino/data_%d/casino_quest.csv"
local EVENT_HERO_COLLECT_PATH = "csv/event/event_hero_collect/data_%d/hero_collect_quest.csv"
local EVENT_PROPHET_TREE_PATH = "csv/event/event_prophet_tree/data_%d/prophet_tree_quest.csv"
local EVENT_LOGIN_PATH = "csv/event/event_login/data_%d/login_reward.csv"
local EVENT_ARENA_RANKING_PATH = "csv/event/event_arena_rank/data_%d/arena_reward.csv"
local EVENT_RELEASE_FESTIVAL_PATH = "csv/event/event_release_festival/data_%d/release_festival.csv"
local EVENT_MARKET_CONFIG_FORMAT = "csv/event/event_market/data_%d/market_config.csv"
local EVENT_MARKET_ITEM_RATE_FORMAT = "csv/event/event_market/data_%d/market_item_rate.csv"
local EVENT_SOUL_SHOP_PATH = "csv/event/event_soul_shop/data_%s/item/soul_shop_%s.csv"
local EVENT_SOUL_SHOP_ITEM_RATE_FORMAT = "csv/event/event_market/data_%d/soul_shop_rate.csv"

local EVENT_QUEST_ROUND_PATH = "csv/client/event_quest_round_config.csv"
local EVENT_MID_AUTUMN_PATH = "csv/event/event_mid_autumn/data_%d"
local EVENT_HALLO_WEEN_PATH = "csv/event/event_halloween/data_%d"
local EVENT_XMAS_PATH = "csv/event/event_christmas/data_%d"
local EVENT_BLACK_FRIDAY_PATH = "csv/event/event_black_friday/data_%d"
local EVENT_NEW_YEAR_PATH = "csv/event/event_new_year/data_%d"
local EVENT_LUNAR_NEW_YEAR_PATH = "csv/event/event_lunar_new_year_2022/data_%d"
local EVENT_LUNAR_PATH_PATH = "csv/event/event_lunar_path/data_%d"
local EVENT_VALENTINE_PATH = "csv/event/event_valentine/data_%d"
local EVENT_NEW_HERO_QUEST_PATH = "csv/event/event_new_hero_quest/data_%d"
local EVENT_NEW_HERO_LOGIN_PATH = "csv/event/event_new_hero_login/data_%d"
local EVENT_NEW_HERO_COLLECTION_PATH = "csv/event/event_new_hero_collection_quest/data_%d"
local EVENT_NEW_HERO_EXCHANGE_PATH = "csv/event/event_new_hero_exchange/data_%d"
local EVENT_NEW_HERO_SPIN_PATH = "csv/event/event_new_hero_spin/data_%d"
local EVENT_MERGE_SERVER_PATH = "csv/event/event_server_merge/data_%d"
local EVENT_EASTER_EGG_PATH = "csv/event/event_easter/data_%d"
local EVENT_PUZZLE_PATH = "csv/event/event_puzzle/data_%d"
local EVENT_SKIN_CHALLENGE_PATH = "csv/event/event_skin_challenge/data_%d"
local EVENT_SKIN_HOT_DEAL_PATH = "csv/event/event_skin_hot_deal/data_%d"
local EVENT_AIRYUU_PATH = "csv/event/event_hero_airyuu/data_%d"
local EVENT_TOWER_OF_EITRI_PATH = "csv/event/event_dragon_tower/data_%d"
local EVENT_SEASONAL_PATH = "csv/event/event_seasonal/data_%d"
local EVENT_BOSS_CHALLENGE_PATH = "csv/event/event_boss_challenge/data_%d"
local EVENT_PIECE_ADVENTURE_PATH = "csv/event/event_piece_adventure/data_%d"
local EVENT_BLACK_FRIDAY_NEW_VERSION_PATH = "csv/event/event_black_friday_sale/data_%d"
local EVENT_THANKS_GIVING_PATH = "csv/event/event_thanks_giving/data_%d"
local EVENT_CHRISTMAS_PATH = "csv/event/event_christmas_2023/data_%d"
local EVENT_NEW_YEAR_2023_PATH = "csv/event/event_new_year_2023/data_%d"
local EVENT_LUNAR_NEW_YEAR_2024_PATH = "csv/event/event_lunar_new_year_2024/data_%d"
local EVENT_VALENTINE_2024_PATH = "csv/event/event_valentine_2024/data_%d"
local EVENT_EASTER_DAY_PATH = "csv/event/event_easter_egg/data_%d"
local EVENT_SUMMER_DAY_PATH = "csv/event/event_summer_day/data_%d"
local EVENT_BLOSSOM_DAY_PATH = "csv/event/event_blossom_day/data_%d"
local EVENT_QIXI_FESTIVAL_PATH = "csv/event/event_qixi/data_%d"
local EVENT_MAY_DAY_PATH = "csv/event/event_may_day/data_%d"

local EVENT_NEW_HERO_BOSS_CHALLENGE_PATH = "csv/event/event_new_hero_challenge_boss/data_%d"
local EVENT_BIRTHDAY_PATH = "csv/event/event_birthday/data_%d"
local EVENT_ZODIAC_PATH = "csv/event/event_zodiac/data_%d"
local EVENT_NEW_HERO_TREASURE_PATH = "csv/event/event_new_hero_treasure/data_%d"

local EVENT_NEW_HERO_SUMMON_PATH = "csv/event/event_new_hero_summon/data_%d"
local EVENT_NEW_HERO_RATE_UP_PATH = "csv/event/event_new_hero_rate_up/data_%d"

local EVENT_HERO_RELEASE_PATH = "csv/event/event_new_hero_release/data_%d"
local EVENT_BATTLE_PASS_PATH = "csv/event/event_battle_pass/data_%d"

local EVENT_NEW_SERVER_WEEK_PATH = "csv/event/event_server_open/data_%d"
local EVENT_KAZETSU_PATH = "csv/event/event_kazetsu/data_%d"
local EVENT_FINDE_BOSS_PATH = "csv/event/event_new_hero_finde_boss/data_%d"
local EVENT_NEW_SERVER_WEEK_PATH_2 = "csv/event/event_server_open_2/data_%d"
local EVENT_NEW_SERVER_WEEK_PATH_3 = "csv/event/event_server_open_3/data_%d"
local EVENT_NEW_SERVER_WEEK_ARENA_PATH = "csv/event/event_server_open_arena/data_%d"
local EVENT_NEW_SERVER_WEEK_SPIN_PATH = "csv/event/event_server_open_spin/data_%d"
local EVENT_NEW_SERVER_WEEK_ARENA_3vs3_PATH = "csv/event/event_server_open_arena_2/data_%d"
local EVENT_NEW_SKIN_PATH = "csv/client/event/event_new_skin/new_skin_pack.csv"

local EVENT_NEW_VIP_PATH = "csv/event/event_vip/data_%d"

--- @class EventConfig
EventConfig = Class(EventConfig)

function EventConfig:Ctor()
    --- @type Dictionary -- {eventTimeType:EventTimeType, data:table}
    self.dataDict = Dictionary()
    --- @type Dictionary -- {eventTimeType:EventTimeType, round : number}
    self.eventQuestRoundConfig = nil
end

--- @return PackOfProducts|Dictionary<number,QuestElementConfig>
--- @param eventTimeType EventTimeType
--- @param dataId number => use when init data 
function EventConfig:GetData(eventTimeType, dataId)
    assert(eventTimeType)
    local data = self.dataDict:Get(eventTimeType)
    if data == nil or data.dataId ~= dataId then
        if eventTimeType == EventTimeType.EVENT_BUNDLE then
            data = ResourceMgr.GetPurchaseConfig():GetBundle():GetPack(dataId)
        elseif eventTimeType == EventTimeType.EVENT_HOT_DEAL then
            data = ResourceMgr.GetPurchaseConfig():GetHotDeal():GetPack(dataId)
        elseif EventTimeType.IsEventPopupQuest(eventTimeType) then
            if dataId == nil then
                XDebug.Error(string.format("dataId is nil: %d", data.dataId))
            end
            if eventTimeType == EventTimeType.EVENT_SUMMON_QUEST then
                data = self:GetQuestId(EVENT_SUMMON_PATH, dataId)
            elseif eventTimeType == EventTimeType.EVENT_PROPHET_TREE_QUEST then
                data = self:GetQuestId(EVENT_PROPHET_TREE_PATH, dataId)
            elseif eventTimeType == EventTimeType.EVENT_ARENA_QUEST then
                data = self:GetQuestId(EVENT_ARENA_PATH, dataId)
            elseif eventTimeType == EventTimeType.EVENT_TAVERN_QUEST then
                data = self:GetQuestId(EVENT_TAVERN_PATH, dataId)
            elseif eventTimeType == EventTimeType.EVENT_CASINO_QUEST then
                data = self:GetQuestId(EVENT_CASINO_PATH, dataId)
            elseif eventTimeType == EventTimeType.EVENT_COLLECT_QUEST then
                data = self:GetQuestId(EVENT_HERO_COLLECT_PATH, dataId)
            end
        elseif eventTimeType == EventTimeType.EVENT_LOGIN then
            require "lua.client.data.Event.EventLoginConfig"
            local eventLoginConfig = EventLoginConfig()
            data = eventLoginConfig:GetConfig(EVENT_LOGIN_PATH, dataId)
        elseif eventTimeType == EventTimeType.EVENT_ARENA_RANKING then
            require "lua.client.data.Event.EventArenaRankingConfig"
            data = EventArenaRankingConfig(EVENT_ARENA_RANKING_PATH, dataId)
        elseif eventTimeType == EventTimeType.EVENT_RELEASE_FESTIVAL then
            require "lua.client.data.Event.EventReleaseFestivalConfig"
            data = EventReleaseFestivalConfig(EVENT_RELEASE_FESTIVAL_PATH, dataId)
        elseif eventTimeType == EventTimeType.EVENT_MARKET then
            require "lua.client.data.Event.EventMarketConfig"
            data = EventMarketConfig(EVENT_MARKET_CONFIG_FORMAT, EVENT_MARKET_ITEM_RATE_FORMAT, dataId)
        elseif eventTimeType == EventTimeType.EVENT_SOUL_SHOP then
            require "lua.client.data.Event.EventMarketNewVersionConfig"
            data = EventMarketNewVersionConfig(EVENT_SOUL_SHOP_PATH, EVENT_SOUL_SHOP_ITEM_RATE_FORMAT, dataId)
        elseif eventTimeType == EventTimeType.EVENT_SALE_OFF then
            data = ResourceMgr.GetPurchaseConfig():GetSaleOff():GetPack(dataId)
        elseif eventTimeType == EventTimeType.EVENT_SERVER_OPEN then
            --hoangpl not used anymore
            require "lua.client.data.Event.EventServerOpen.ServerOpenData"
            data = ServerOpenData(dataId)
            --[[
        require "lua.client.data.ServerOpen.EventServerOpenConfig" -- HOANGPL
        data = EventServerOpenConfig()
         --]]
        elseif eventTimeType == EventTimeType.EVENT_RATE_UP then
            require "lua.client.data.Event.EventRateUp"
            data = EventRateUp(dataId)
        elseif eventTimeType == EventTimeType.EVENT_ARENA_PASS then
            data = ResourceMgr.GetPurchaseConfig():GetArenaPass():GetPack(dataId)
        elseif eventTimeType == EventTimeType.EVENT_DAILY_QUEST_PASS then
            data = ResourceMgr.GetPurchaseConfig():GetDailyQuestPass():GetPack(dataId)
        elseif eventTimeType == EventTimeType.EVENT_MID_AUTUMN then
            require "lua.client.data.Event.EventMidAutumnConfig"
            data = EventMidAutumnConfig(string.format(EVENT_MID_AUTUMN_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_HALLOWEEN then
            require "lua.client.data.Event.EventHalloweenConfig"
            data = EventHalloweenConfig(string.format(EVENT_HALLO_WEEN_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_XMAS then
            require "lua.client.data.Event.EventXmasConfig"
            data = EventXmasConfig(string.format(EVENT_XMAS_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_BLACK_FRIDAY then
            require "lua.client.data.Event.EventBlackFridayConfig"
            data = EventBlackFridayConfig(string.format(EVENT_BLACK_FRIDAY_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_YEAR then
            require "lua.client.data.Event.EventNewYearConfig"
            data = EventNewYearConfig(string.format(EVENT_NEW_YEAR_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_LUNAR_NEW_YEAR_2022 then
            require "lua.client.data.Event.EventLunarNewYear.EventLunarNewYearConfig"
            data = EventLunarNewYearConfig(string.format(EVENT_LUNAR_NEW_YEAR_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_VALENTINE then
            require "lua.client.data.Event.EventValentine.EventValentineConfig"
            data = EventValentineConfig(string.format(EVENT_VALENTINE_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_LUNAR_PATH then
            require "lua.client.data.Event.EventLunarPath.EventLunarPathConfig"
            data = EventLunarPathConfig(string.format(EVENT_LUNAR_PATH_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_QUEST then
            require "lua.client.data.Event.EventNewHeroQuest.EventNewHeroQuestConfig"
            data = EventNewHeroQuestConfig(string.format(EVENT_NEW_HERO_QUEST_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_LOGIN then
            require "lua.client.data.Event.EventNewHero.EventNewHeroLoginConfig"
            data = EventNewHeroLoginConfig(string.format(EVENT_NEW_HERO_LOGIN_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_BUNDLE then
            data = ResourceMgr.GetPurchaseConfig():GetNewHeroBundle():GetPack(dataId)
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_COLLECTION then
            require "lua.client.data.Event.EventNewHeroCollection.EventNewHeroCollectionConfig"
            data = EventNewHeroCollectionConfig(string.format(EVENT_NEW_HERO_COLLECTION_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_EXCHANGE then
            require "lua.client.data.Event.EventNewHeroExchange.EventNewHeroExchangeConfig"
            data = EventNewHeroExchangeConfig(string.format(EVENT_NEW_HERO_EXCHANGE_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_SPIN then
            require "lua.client.data.Event.EventNewHero.Spin.EventNewHeroSpinConfig"
            data = EventNewHeroSpinConfig(string.format(EVENT_NEW_HERO_SPIN_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_MERGE_SERVER then
            require "lua.client.data.Event.EventMergeServer.EventMergeServerConfig"
            data = EventMergeServerConfig(string.format(EVENT_MERGE_SERVER_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_SUMMON then
            require "lua.client.data.Event.EventNewHero.Summon.EventNewHeroSummonConfig"
            data = EventNewHeroSummonConfig(string.format(EVENT_NEW_HERO_SUMMON_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_EASTER_EGG then
            require "lua.client.data.Event.EventEasterEgg.EventEasterEggConfig"
            data = EventEasterEggConfig(string.format(EVENT_EASTER_EGG_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_BOSS_CHALLENGE then
            require "lua.client.data.Event.EventNewHero.BossChallenge.EventNewHeroBossChallengeConfig"
            data = EventNewHeroBossChallengeConfig(string.format(EVENT_NEW_HERO_BOSS_CHALLENGE_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_BIRTHDAY then
            require "lua.client.data.Event.EventBirthday.EventBirthdayConfig"
            data = EventBirthdayConfig(string.format(EVENT_BIRTHDAY_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_ZODIAC then
            require "lua.client.data.Event.EventZodiac.EventZodiacConfig"
            data = EventZodiacConfig(string.format(EVENT_ZODIAC_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_TREASURE then
            require "lua.client.data.Event.EventNewHeroTreasure.EventNewHeroTreasureConfig"
            data = EventNewHeroTreasureConfig(string.format(EVENT_NEW_HERO_TREASURE_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_RATE_UP then
            require "lua.client.data.Event.EventNewHero.Summon.EventNewHeroSummonConfig"
            data = EventNewHeroSummonConfig(string.format(EVENT_NEW_HERO_RATE_UP_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_SKIN_BUNDLE then
            data = ResourceMgr.GetPurchaseConfig():GetNewHeroSkinBundleStore():GetPack(dataId)
        elseif eventTimeType == EventTimeType.EVENT_SKIN_BUNDLE then
            data = ResourceMgr.GetPurchaseConfig():GetSkinBundleStore():GetPack(dataId)
        elseif eventTimeType == EventTimeType.EVENT_IDLE_EFFECT_BUNDLE then
            data = ResourceMgr.GetPurchaseConfig():GetIdleEffectBundle():GetPack(dataId)
        elseif eventTimeType == EventTimeType.EVENT_HERO_RELEASE then
            require "lua.client.data.Event.EventHeroRelease.EventHeroReleaseConfig"
            data = EventHeroReleaseConfig(string.format(EVENT_HERO_RELEASE_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_BATTLE_PASS then
            require "lua.client.data.Event.EventBattlePass.EventBattlePassConfig"
            data = EventBattlePassConfig(string.format(EVENT_BATTLE_PASS_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_SERVER_WEEK then
            require "lua.client.data.Event.EventNewServerWeek.EventNewServerWeekConfig"
            data = EventNewServerWeekConfig(string.format(EVENT_NEW_SERVER_WEEK_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_SERVER_WEEK_2 then
            require "lua.client.data.Event.EventNewServerWeek.EventNewServerWeek2Config"
            data = EventNewServerWeek2Config(string.format(EVENT_NEW_SERVER_WEEK_PATH_2, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_SERVER_WEEK_3 then
            require "lua.client.data.Event.EventNewServerWeek.EventNewServerWeek3Config"
            data = EventNewServerWeek3Config(string.format(EVENT_NEW_SERVER_WEEK_PATH_3, dataId))
        elseif eventTimeType == EventTimeType.EVENT_SERVER_OPEN_ARENA then
            require "lua.client.data.Event.EventNewServerWeek.EventNewServerWeekArenaConfig"
            data = EventNewServerWeekArenaConfig(string.format(EVENT_NEW_SERVER_WEEK_ARENA_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_SERVER_OPEN_SPIN then
            require "lua.client.data.Event.EventNewServerWeek.EventNewServerWeekSpinConfig"
            data = EventNewServerWeekSpinConfig(string.format(EVENT_NEW_SERVER_WEEK_SPIN_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_SERVER_OPEN_ARENA_3V3 then
            require "lua.client.data.Event.EventNewServerWeek.EventNewServerWeekArena3vs3Config"
            data = EventNewServerWeekArena3vs3Config(string.format(EVENT_NEW_SERVER_WEEK_ARENA_3vs3_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_KAZETSU then
            require "lua.client.data.Event.EventKazetsu.EventKazetsuConfig"
            data = EventKazetsuConfig(string.format(EVENT_KAZETSU_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_FINDE_BOSS then
            require "lua.client.data.Event.EventFindeBoss.EventFindeBossChallengeConfig"
            data = EventFindeBossChallengeConfig(string.format(EVENT_FINDE_BOSS_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_PUZZLE then
            require "lua.client.data.Event.EventPuzzle.EventPuzzleConfig"
            data = EventPuzzleConfig(string.format(EVENT_PUZZLE_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_VIP then
            require "lua.client.data.Event.EventNewVip.EventNewVipConfig"
            data = EventNewVipConfig(string.format(EVENT_NEW_VIP_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_SKIN_CHALLENGE then
            require "lua.client.data.Event.EventSkinChallenge.EventSkinChallengeConfig"
            data = EventSkinChallengeConfig(string.format(EVENT_SKIN_CHALLENGE_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_SKIN_HOT_DEAL then
            require "lua.client.data.Event.EventSkinHotDeal.EventSkinHotDealConfig"
            data = EventSkinHotDealConfig(string.format(EVENT_SKIN_HOT_DEAL_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_AIRYUU then
            require "lua.client.data.Event.EventAiryuu.EventAiryuuConfig"
            data = EventAiryuuConfig(string.format(EVENT_AIRYUU_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_TOWER_OF_EITRI then
            require "lua.client.data.Event.EventTowerOfEitri.EventTowerOfEitriConfig"
            data = EventTowerOfEitriConfig(string.format(EVENT_TOWER_OF_EITRI_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_SEASONAL then
            require "lua.client.data.Event.EventSeasonal.EventSeasonalConfig"
            data = EventSeasonalConfig(string.format(EVENT_SEASONAL_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_BOSS_CHALLENGE then
            require "lua.client.data.Event.EventBossChallenge.EventBossChallengeConfig"
            data = EventBossChallengeConfig(string.format(EVENT_BOSS_CHALLENGE_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_PIECE_ADVENTURE then
            require "lua.client.data.Event.EventPieceAdventure.EventPieceAdventureConfig"
            data = EventPieceAdventureConfig(string.format(EVENT_PIECE_ADVENTURE_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_BLACK_FRIDAY_SALE then
            require "lua.client.data.Event.EventBlackFridayNewVersion.EventBlackFridayNewVersionConfig"
            data = EventBlackFridayNewVersionConfig(string.format(EVENT_BLACK_FRIDAY_NEW_VERSION_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_THANKS_GIVING then
            require "lua.client.data.Event.EventThanksGiving.EventThanksGivingConfig"
            data = EventThanksGivingConfig(string.format(EVENT_THANKS_GIVING_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_CHRISTMAS then
            require "lua.client.data.Event.EventChristmas.EventChristmasConfig"
            data = EventChristmasConfig(string.format(EVENT_CHRISTMAS_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_NEW_YEAR_2023 then
            require "lua.client.data.Event.EventNewYear2023.EventNewYear2023Config"
            data = EventNewYear2023Config(string.format(EVENT_NEW_YEAR_2023_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_LUNAR_NEW_YEAR_2024 then
            require "lua.client.data.Event.EventLunarNewYear2024.EventLunarNewYear2024Config"
            data = EventLunarNewYear2024Config(string.format(EVENT_LUNAR_NEW_YEAR_2024_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_VALENTINE_2024 then
            require "lua.client.data.Event.EventValentine2024.EventValentine2024Config"
            data = EventValentine2024Config(string.format(EVENT_VALENTINE_2024_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_EASTER_DAY then
            require "lua.client.data.Event.EventEasterDay.EventEasterDayConfig"
            data = EventEasterDayConfig(string.format(EVENT_EASTER_DAY_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_SUMMER_DAY then
            require "lua.client.data.Event.EventSummerDay.EventSummerDayConfig"
            data = EventSummerDayConfig(string.format(EVENT_SUMMER_DAY_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_BLOSSOM then
            require "lua.client.data.Event.EventBlossomDayConfig.EventBlossomDayConfig"
            data = EventBlossomDayConfig(string.format(EVENT_BLOSSOM_DAY_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_QIXI then
            require "lua.client.data.Event.EventQixiFestival.EventQixiFestivalConfig"
            data = EventQixiFestivalConfig(string.format(EVENT_QIXI_FESTIVAL_PATH, dataId))
        elseif eventTimeType == EventTimeType.EVENT_MAY_DAY then
            require "lua.client.data.Event.EventMayDay.EventMayDayConfig"
            data = EventMayDayConfig(string.format(EVENT_MAY_DAY_PATH, dataId))
        else
            XDebug.Error(string.format("event_time_type don't support: %d", eventTimeType))
            return nil
        end
        if data ~= nil then
            data.dataId = dataId
            self.dataDict:Add(eventTimeType, data)
        end
    end
    return data
end

--- @return Dictionary
--- @param pathFormat string
--- @param dataId number
function EventConfig:GetQuestId(pathFormat, dataId)
    local path = string.format(pathFormat, dataId)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s, %s", pathFormat, dataId))
        return
    end
    --- @type Dictionary
    local questDict = Dictionary()
    --- @type QuestElementConfig
    local questConfig
    for i = 1, #parsedData do
        local questId = parsedData[i].quest_id
        if questId ~= nil then
            questConfig = QuestElementConfig.GetInstanceFromCsv(parsedData[i])
            questDict:Add(tonumber(questId), questConfig)
        else
            questConfig:AddResData(RewardInBound.CreateByParams(parsedData[i]))
        end
    end
    return questDict
end

--- @return number
--- @param eventTimeType EventTimeType
function EventConfig:GetEventQuestRoundConfigByType(eventTimeType)
    if self.eventQuestRoundConfig == nil then
        self.eventQuestRoundConfig = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(EVENT_QUEST_ROUND_PATH)
        for i = 1, #parsedData do
            local eventTimeType = tonumber(parsedData[i].event_time_type)
            local round = tonumber(parsedData[i].round)
            self.eventQuestRoundConfig:Add(eventTimeType, round)
        end
    end
    if self.eventQuestRoundConfig:IsContainKey(eventTimeType) then
        return self.eventQuestRoundConfig:Get(eventTimeType)
    end
    return 1
end

--- @return Dictionary
function EventConfig:GetNewSkinConfig()
    if self.eventNewSkinConfig == nil then
        self.eventNewSkinConfig = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(EVENT_NEW_SKIN_PATH)
        local listItem = List()
        for i = 1, #parsedData do
            local id = parsedData[i].id
            if (id ~= nil) then
                local skinId = tonumber(parsedData[i].skin_id)
                local heroId = tonumber(parsedData[i].hero_id)
                self.eventNewSkinConfig:Add("heroId", heroId)
                self.eventNewSkinConfig:Add("skinId", skinId)
            end
            local item = RewardInBound.CreateBySingleParam(tonumber(parsedData[i].res_type), tonumber(parsedData[i].res_id), tonumber(parsedData[i].res_number))
            listItem:Add(item)
        end
        self.eventNewSkinConfig:Add("listItem", listItem)
    end
    return self.eventNewSkinConfig
end

return EventConfig

