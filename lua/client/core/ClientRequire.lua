function RequireBase()
    require "lua.libs.LogUtils"
    require "lua.libs.RandomHelper"
    require "lua.libs.StopWatch"
    require "lua.libs.TableUtils"
    require "lua.client.utils.ClientStopWatch"
    require "lua.client.utils.SHA2"
    require "lua.client.utils.gzip.GzipDepacker"
    require "lua.client.utils.BitUtils"
    require "lua.client.utils.UIUtils"
    require "lua.client.utils.BuyUtils"
    require "lua.client.utils.XDebug"
    require "lua.client.utils.ResourceLoadUtils"
    require "lua.client.utils.SortUtils"
    require "lua.client.utils.ClientConfigUtils"
    require "lua.client.utils.ClientMathUtils"
    require "lua.client.utils.DOTweenUtils"
    require "lua.client.utils.smartPool.SmartPool"
    require "lua.client.utils.jobSystem.Job"
    require "lua.client.utils.RxUtils"
    require "lua.client.config.const.DeviceOs"
    require "lua.client.config.BattleBackgroundUtils"
    require "lua.client.utils.TimeCountDown"
    require "lua.client.scene.ui.utils.PrefabView"
    require "lua.client.scene.ui.common.BgWorldView"
    require "lua.client.scene.ui.home.uiHeroMenu.PreviewHeroMenu"
end

function RequireSmartPool()
    local function RequireUIPoolType()
        require "lua.client.scene.ui.common.UIPrefabView"
        require "lua.client.scene.ui.common.IconView"
        require "lua.client.scene.ui.common.MotionIconView"
        require "lua.client.scene.ui.common.UITabItem"

        UIPoolType = {
            --- Lua GameObject
            RootIconView = require("lua.client.scene.ui.common.RootIconView"),
            HeroIconView = require("lua.client.scene.ui.common.HeroIconView"),
            HeroIconView2 = require("lua.client.scene.ui.common.HeroIconView2"),
            RaiseHeroIconView = require("lua.client.scene.ui.common.RaiseHeroIconView"),
            RaiseHeroPickIconView = require("lua.client.scene.ui.home.uiRaisePickHero.HeroRaisePickIconView"),
            DungeonHeroIconView = require("lua.client.scene.ui.common.DungeonHeroIconView"),
            HeroCardItemView = require("lua.client.scene.ui.common.HeroCardItemView"),
            HiddenCardItemView = require("lua.client.scene.ui.common.HiddenCardItemView"),
            DailyRewardItemView = require("lua.client.scene.ui.common.DailyRewardItemView"),
            DailyRewardMultiItemView = require("lua.client.scene.ui.common.DailyRewardMultiItemView"),
            KazetsuDailyRewardItemView = require("lua.client.scene.ui.home.uiEventKazetsu.eventLayout.EventDailyLogin.KazetsuDailyRewardItemView"),
            KazetsuLastDailyRewardItemView = require("lua.client.scene.ui.home.uiEventKazetsu.eventLayout.EventDailyLogin.KazetsuLastDailyRewardItemView"),
            NewServerWeekDailyRewardItemView = require("lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventDailyLogin.NewServerWeekDailyRewardItemView"),
            NewServerWeekLastDailyRewardItemView = require("lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventDailyLogin.NewServerWeekLastDailyRewardItemView"),
            BlackFridayLastDailyRewardView = require("lua.client.scene.ui.home.uiEventBlackFriday.uiEventBlackFridayLayout.EventDailyCheckin.BlackFridayLastDailyRewardView"),
            BlackFridayRewardMultiItemView = require("lua.client.scene.ui.common.DailyRewardMultiItemView"),
            DailyRewardXmasView = require ("lua.client.scene.ui.home.uiEventXmas.uiEventXmasLayout.checkIn.DailyRewardXmasView"),
            DailyRewardLunarNewYearView = require ("lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.dailyCheckin.DailyRewardLunarNewYearView"),
            DailyRewardHalloweenView = require("lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDailyCheckin.DailyRewardHalloweenView"),
            AvatarIconView = require("lua.client.scene.ui.common.AvatarIconView"),
            BorderIconView = require("lua.client.scene.ui.common.BorderIconView"),
            ItemIconView = require("lua.client.scene.ui.common.ItemIconView"),
            ZodiacExchangePoolView = require("lua.client.scene.ui.common.ZodiacExchangePoolView"),
            ZodiacExchangeItemView = require("lua.client.scene.ui.common.ZodiacExchangeItemView"),
            RateView = require("lua.client.scene.ui.common.RateView"),
            ValentineOpenCardItemView = require("lua.client.scene.ui.home.uiEventValentine.eventLayout.openCard.ValentineOpenCardItemView"),
            PieceAdventureOpenCardItemView = require("lua.client.scene.ui.home.uiEventPieceAdventure.uiEventPieceAdventureLayout.EventPieceAdventure.PieceAdventureOpenCardItemView"),
            LunarNewYear2024CardItemView = require("lua.client.scene.ui.home.uiEventLunarNewYear2024.EventLayout.bingo.LunarNewYear2024CardItemView"),
            MayDayCardItemView = require("lua.client.scene.ui.home.uiEventMayDay.EventLayout.bingo.MayDayCardItemView"),
            LunarNewYear2024BingoItemView = require("lua.client.scene.ui.home.uiEventLunarNewYear2024.EventLayout.bingo.LunarNewYear2024BingoItemView"),
            MayDayBingoItemView = require("lua.client.scene.ui.home.uiEventMayDay.EventLayout.bingo.MayDayBingoItemView"),
            RoundCardWishItemView = require("lua.client.scene.ui.home.uiEventValentine.eventLayout.openCard.RoundCardWishItemView"),
            ItemIconEffectView = require("lua.client.scene.ui.common.ItemIconEffectView"),
            ListHeroRecommendItemView = require("lua.client.scene.ui.home.uiWiki.herorecommend.ListHeroRecommendItemView"),
            ResourceMappingResourceItemView = require("lua.client.scene.ui.home.uiWiki.resourceMapping.ResourceMappingResourceItemView"),
            FeatureUnlockItemView = require("lua.client.scene.ui.home.uiWiki.featureUnlock.FeatureUnlockItemView"),
            ResourceMappingFeatureItemView = require("lua.client.scene.ui.home.uiWiki.resourceMapping.ResourceMappingFeatureItemView"),
            ItemInfoView = require("lua.client.scene.ui.common.ItemInfoView"),
            SkillHeroIconView = require("lua.client.scene.ui.common.SkillHeroView"),
            SkillSummonerIconView = require("lua.client.scene.ui.common.SkillSummonerView"),
            MoneyIconView = require("lua.client.scene.ui.common.MoneyIconView"),
            DiceItemView = require("lua.client.scene.ui.common.DiceItemView"),
            EasterEggExchangeItemView = require("lua.client.scene.ui.common.EasterEggExchangeItemView"),
            IdleEffectInfo = require("lua.client.scene.ui.common.IdleEffectInfo"),
            QuickBattleTicketView = require("lua.client.scene.ui.common.QuickBattleTicketView"),
            HeroIconNodeView = require("lua.client.scene.ui.common.HeroIconNodeView"),
            HeroIconSelectView = require("lua.client.scene.ui.common.HeroIconSelectView"),
            UIButtonStageView = require("lua.client.scene.ui.home.uiSelectMapPVE.stage.UIButtonStageView"),
            DungeonShopItemView = require("lua.client.scene.ui.common.DungeonShopItemView"),
            SwitchCharacterIconView = require("lua.client.scene.ui.home.uiSwitchCharacter.SwitchCharacterIconView"),
            StatInformationView = require("lua.client.scene.ui.common.prefabHeroInfo.StatInformationView"),
            ButtonBuyView = require("lua.client.scene.ui.common.ButtonBuyView"),
            ButtonHelpRandomView = require("lua.client.scene.ui.common.ButtonHelpRandomView"),
            FragmentIconView = require("lua.client.scene.ui.common.FragmentIconView"),
            HeroMaterialIconView = require("lua.client.scene.ui.common.HeroMaterialIconView"),
            ModeShopIconView = require("lua.client.scene.ui.common.ModeShopIconView"),
            HeroSummonBaseIconView = require("lua.client.scene.ui.common.HeroSummonBaseIconView"),
            MoneyBarView = require("lua.client.scene.ui.common.MoneyBarView"),
            MoneyCostBarView = require("lua.client.scene.ui.common.MoneyCostBarView"),
            SlotHeroIconView = require("lua.client.scene.ui.common.SlotHeroIconView"),
            SlotHeroIconView2 = require("lua.client.scene.ui.common.SlotHeroIconView2"),
            RequirementHeroIconView = require("lua.client.scene.ui.common.RequirementHeroIconView"),
            RequirementHeroInfoView = require("lua.client.scene.ui.common.RequirementHeroInfoView"),
            UITavernQuestView = require("lua.client.scene.ui.common.UITavernQuestView"),
            UITopNewHeroItemView = require("lua.client.scene.ui.common.UITopNewHeroItemView"),
            UIGrowUpTreasureItemView= require("lua.client.scene.ui.common.UIGrowUpTreasureItemView"),
            UIEventKazetsuQuestItem = require("lua.client.scene.ui.home.uiEventKazetsu.eventLayout.KazetsuGift.UIEventKazetsuQuestItem"),
            UITreasureItemView = require("lua.client.scene.ui.common.UITreasureItemView"),
            UIPrefabHeroList2View = require("lua.client.scene.ui.common.prefabHeroList.UIPrefabHeroList2View"),
            UIPrefabTeamView = require("lua.client.scene.ui.common.prefabTeam.UIPrefabTeamView"),
            VipDescriptionView = require("lua.client.scene.ui.common.VipDescriptionView"),
            BonusTagItemView = require("lua.client.scene.ui.common.BonusTagItemView"),
            InputNumberView = require("lua.client.scene.ui.common.InputNumberView"),
            SmallInputNumberView = require("lua.client.scene.ui.common.SmallInputNumberView"),
            StatUpgradeView = require("lua.client.scene.ui.common.StatUpgradeView"),
            UIStatItemUpgradeView = require("lua.client.scene.ui.common.UIStatItemUpgradeView"),
            SelectServerView = require("lua.client.scene.ui.common.SelectServerView"),
            LeaderBoardItemView = require("lua.client.scene.ui.common.LeaderBoardItemView"),
            LeaderBoardNewHeroItemView = require("lua.client.scene.ui.common.LeaderBoardNewHeroItemView"),
            StageRewardItemVew = require("lua.client.scene.ui.common.DefenseModeStageRewardItemView"),
            RaidStageView = require("lua.client.scene.ui.common.RaidStageView"),
            UIFriendItemView = require("lua.client.scene.ui.common.UIFriendItemView"),
            UIBlockPlayerItemView = require("lua.client.scene.ui.common.UIBlockPlayerItemView"),
            UIDomainInvitationItemView = require("lua.client.scene.ui.common.UIDomainInvitationItemView"),
            UIDomainTeamItemView = require("lua.client.scene.ui.common.UIDomainTeamItemView"),
            UIDomainMemberVerifyItemView = require("lua.client.scene.ui.common.UIDomainMemberVerifyItemView"),
            UIDomainMemberSearchItemView = require("lua.client.scene.ui.common.UIDomainMemberSearchItemView"),
            SelectLanguageItemView = require("lua.client.scene.ui.common.SelectLanguageItemView"),
            FriendRankingPointItemView = require("lua.client.scene.ui.common.FriendRankingPointItemView"),
            FriendRankingRewardItemView = require("lua.client.scene.ui.common.FriendRankingRewardItemView"),
            ChatBoxView = require("lua.client.scene.ui.common.ChatBoxView"),
            UserChatBoxView = require("lua.client.scene.ui.common.UserChatBoxView"),
            GuestChatBoxView = require("lua.client.scene.ui.common.GuestChatBoxView"),
            DamageStatItemView = require("lua.client.scene.ui.common.DamageStatItemView"),
            ArenaBattleItemView = require("lua.client.scene.ui.common.ArenaBattleItemView"),
            ArenaChestItemView = require("lua.client.scene.ui.common.ArenaChestItemView"),
            ArenaRewardItemView = require("lua.client.scene.ui.common.ArenaRewardItemView"),
            BossChallengeRewardItemView = require("lua.client.scene.ui.common.BossChallengeRewardItemView"),
            ArenaRecordItemView = require("lua.client.scene.ui.common.ArenaRecordItemView"),
            ArenaTeamOpponentItemView = require("lua.client.scene.ui.home.uiArenaTeamSearch.ArenaTeamOpponentItemView"),
            GuildWarRecordItemView = require("lua.client.scene.ui.home.uiGuildWarPhase3TeamInfo.uiGuildWarRecord.GuildWarRecordItemView"),
            BattleLogItemView = require("lua.client.scene.ui.common.BattleLogItemView"),
            UITapToCloseView = require("lua.client.scene.ui.common.UITapToCloseView"),
            VipIconView = require("lua.client.scene.ui.common.VipIconView"),
            ArenaRankingItemView = require("lua.client.scene.ui.common.ArenaRankingItemView"),
            BossChallengeRankingItemView = require("lua.client.scene.ui.common.BossChallengeRankingItemView"),
            UIMailItemView = require("lua.client.scene.ui.common.UIMailItemView"),
            QuestItemView = require("lua.client.scene.ui.home.uiQuest.questItem.QuestItemView"),
            ApplyGuildSlotItemView = require("lua.client.scene.ui.home.uiGuildApply.UIApplyGuildSlotItemView"),
            MemberSlotItemView = require("lua.client.scene.ui.home.uiGuildMain.UIGuildMemberSlotItemView"),
            GuildApplicationItem = require("lua.client.scene.ui.home.uiGuildApplication.UIGuildApplicationItem"),
            GuildLogItem = require("lua.client.scene.ui.home.uiGuildLog.UIGuildLogItemView"),
            QuestTreeNodeItem = require("lua.client.scene.ui.home.uiPopupQuestTree.UIQuestTreeNodeItem"),
            EventPackageItem = require("lua.client.scene.ui.home.uiEvent.purchase.UIEventPackageItemView"),
            EventPackageTabItem = require("lua.client.scene.ui.home.uiEvent.UIEventPackageTabItem"),
            UITopTabItem = require("lua.client.scene.ui.home.uiEvent.UITopTabItem"),
            EventSubButtonItem = require("lua.client.scene.ui.home.uiEvent.UIEventSubButtonItem"),
            EventQuestItem = require("lua.client.scene.ui.home.uiEvent.quest.UIEventQuestItem"),
            UIStarBackgroundView = require("lua.client.scene.ui.home.uiEventZodiac.layout.constellation.UIStarBackgroundView"),
            BattlePassQuestItem = require("lua.client.scene.ui.common.BattlePassQuestItemView"),
            BattlePassExchangeItem = require("lua.client.scene.ui.common.BattlePassExchangeItem"),
            LunarNewYearExclusiveOfferItem = require("lua.client.scene.ui.common.LunarNewYearExclusiveOfferItem"),
            ScrollRewardItem = require("lua.client.scene.ui.common.ScrollRewardItem"),
            BattleHistoryItem = require("lua.client.scene.ui.common.BattleHistoryItem"),
            ServerBuildingProgress = require("lua.client.scene.ui.common.ServerBuildingProgress"),
            TowerOfEitriPopupQuestItem = require("lua.client.scene.ui.common.TowerOfEitriPopupQuestItem"),
            DotSelect = require("lua.client.scene.ui.common.DotSelect"),
            PurchaseBundleItem = require("lua.client.scene.ui.common.PurchaseBundleItem"),
            DifficultRewardItem = require("lua.client.scene.ui.common.DifficultRewardItem"),
            EventAiryuuCheckinItem = require("lua.client.scene.ui.common.EventAiryuuCheckinItem"),
            EventSeasonalCheckinItem = require("lua.client.scene.ui.common.EventSeasonalCheckinItem"),
            EventSeasonalExchangeItem = require("lua.client.scene.ui.common.EventSeasonalExchangeItem"),
            EventSeasonalQuestItem = require("lua.client.scene.ui.common.EventSeasonalQuestItem"),
            SkinChallengeExchangeItem = require("lua.client.scene.ui.common.SkinChallengeExchangeItem"),
            UIResItemRawPack = require("lua.client.scene.ui.home.uiIapShop.UIResItemRawPack"),
            UIPrefabHeroSlotView = require("lua.client.scene.ui.common.prefabHeroSlot.UIPrefabHeroSlotView"),
            FactionCompanionView = require("lua.client.scene.ui.common.FactionCompanionView"),
            StatCompanionView = require("lua.client.scene.ui.common.StatCompanionView"),
            GuildLogoSelectItem = require("lua.client.scene.ui.home.uiSelectGuildLogo.GuildLogoSelectItem"),
            AvatarGameOverView = require("lua.client.scene.ui.common.AvatarGameOverView"),
            WorldMapGateItem = require("lua.client.scene.ui.home.uiWorldMap.UIWorldMapGateItem"),
            UITowerRecordItem = require("lua.client.scene.ui.home.uiTowerBattleRecord.UITowerRecordItem"),
            Reward1ItemView = require("lua.client.scene.ui.common.UIPopupReward1ItemView"),
            EventArenaRankingItem = require("lua.client.scene.ui.home.uiEvent.arenaRanking.UIEventArenaRankingItem"),
            GuildWarRegistrationItem = require("lua.client.scene.ui.home.uiGuildWarRegistration.uiGuildWarRegistrationItem.UIGuildWarRegistrationItem"),
            HeroSlotWorldFormation = require("lua.client.scene.ui.home.uiFormation2.heroSlotWorldFormation.HeroSlotWorldFormation"),
            KazetsuTrialHeroSlotWorldFormation = require("lua.client.scene.ui.home.uiKazetsuTrialFormation.heroSlotWorldFormation.KazetsuTrialHeroSlotWorldFormation"),
            GuildWarAreaWorld = require("lua.client.scene.ui.home.uiGuildWarArea.guildWarArea.GuildWarArea"),
            GuildWarDefenseWorldBase = require("lua.client.scene.ui.home.uiGuildWarArea.guildWarDefenseWorldBase.GuildWarDefenseWorldBase"),
            GuildDungeonBossStand = require("lua.client.scene.ui.home.uiGuildDungeon.guildDungeonWorldView.GuildDungeonBossStand"),
            GuildDailyBossMilestoneReward = require("lua.client.scene.ui.home.uiGuildDailyBoss.guildDailyBossMilestoneReward.GuildDailyBossMilestoneReward"),
            UIEventReleaseFestivalItem = require("lua.client.scene.ui.home.uiEvent.releaseFestival.UIEventReleaseFestivalItem"),
            ExchangeItemView = require("lua.client.scene.ui.common.ExchangeItemView"),
            ExchangeHeroView = require("lua.client.scene.ui.common.ExchangeHeroView"),
            EventExchangePanel = require("lua.client.scene.ui.home.uiEvent.exchange.EventExchangePanel"),
            MaterialItemView = require("lua.client.scene.ui.common.MaterialItemView"),
            LobbyTeamItemView = require("lua.client.scene.ui.common.LobbyTeamItemView"),
            GuildDonateItemView = require("lua.client.scene.ui.common.GuildDonateItemView"),
            InputSliderView = require("lua.client.scene.ui.common.InputSliderView"),
            GuildDonateHistoryItemView = require("lua.client.scene.ui.common.GuildDonateHistoryItemView"),
            DonateHelpItemView = require("lua.client.scene.ui.common.DonateHelpItemView"),
            QuickBattleItemView = require("lua.client.scene.ui.common.QuickBattleItemView"),
            RewardPointItemView = require("lua.client.scene.ui.common.RewardPointItemView"),
            EventServerOpenItemView = require("lua.client.scene.ui.common.EventServerOpenItemView"),
            UIGrowthMilestoneItem = require("lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopLevelPassLayout.UIGrowthMilestoneItem"),
            UIIapTigerPathMilestoneItem = require("lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.tigerPath.UIIapTigerPathMilestoneItem"),
            UIIapLegacyPathItem = require("lua.client.scene.ui.home.uiEventBirthday.layout.legacy.UIIapLegacyPathItem"),
            UIIapArenaPassMilestone = require("lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapPassLayout.UIIapArenaPassMilestoneItem"),
            MultiEvolveItemView = require("lua.client.scene.ui.home.uiMultiEvolve.MultiEvolveItemView"),
            DungeonBuffCardView = require("lua.client.scene.ui.common.DungeonBuffCardView"),
            TalentSelectItemView = require("lua.client.scene.ui.common.TalentSelectItemView"),
            Talent2SelectItemView = require("lua.client.scene.ui.common.Talent2SelectItemView"),
            GuildWarBattleResultView = require("lua.client.scene.ui.common.GuildWarBattleResultView"),
            IapTilePackItem = require("lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackItem"),
            IapTilePackLargeItem = require("lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackLargeItem"),
            IapTilePackZodiacItem = require("lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackZodiacItem"),
            SkinIconView = require("lua.client.scene.ui.common.SkinIconView"),
            SkinCardView = require("lua.client.scene.ui.common.SkinCardView"),
            GuildIconView = require("lua.client.scene.ui.common.GuildIconView"),
            FeedBeastLevelRewardItem = require("lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.feedTheBeast.FeedBeastLevelRewardItem"),
            WishRewardItem = require("lua.client.scene.ui.home.uiEventNewYear2023.EventLayout.luckyWish.WishRewardItem"),
            PieceAdventureLevelRewardItem = require("lua.client.scene.ui.home.uiEventPieceAdventure.uiEventPieceAdventureLayout.EventPieceAdventure.PieceAdventureLevelRewardItem"),
            LunarNewYearBingo2024RewardItemView = require("lua.client.scene.ui.home.uiEventLunarNewYear2024.EventLayout.bingo.LunarNewYearBingo2024RewardItemView"),
            MayDayBingoRewardItemView = require("lua.client.scene.ui.home.uiEventMayDay.EventLayout.bingo.MayDayRewardItemView"),
            LionDanceLevelRewardItem = require("lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.lionDance.LionDanceLevelRewardItem"),
            ExchangeMidAutumnItemView = require("lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.exchange.ExchangeMidAutumnItemView"),
            GemBoxMidAutumnItemView = require("lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.gemBox.GemBoxMidAutumnItemView"),
            GemBoxBlackFridayItemView = require("lua.client.scene.ui.home.uiEventBlackFriday.uiEventBlackFridayLayout.EventGemPack.GemBoxBlackFridayItemView"),
            GemBoxNewYearItemView =  require("lua.client.scene.ui.home.uiEventNewYear.uiEventLayout.exchange.GemBoxNewYearItemView"),
            StageIdleRewardItemView = require("lua.client.scene.ui.home.uiDefenseMap.StageIdleRewardItemView"),
            BubbleView = require("lua.client.scene.ui.home.uiDefenseMode.LandSelect.BubbleView"),
            TowerResultItemView = require("lua.client.scene.ui.common.TowerResultItemView"),
            WorldFormation = require("lua.client.scene.ui.home.uiFormation2.dungeonWorldFormation.DungeonWorldFormation"),
            ChestIgnatiusItemView = require("lua.client.scene.ui.common.ChestIgnatiusItemView"),
            ChestKazetsuItemView = require("lua.client.scene.ui.common.ChestKazetsuItemView"),
            ChestBirthdayItemView = require("lua.client.scene.ui.common.ChestBirthdayItemView"),
            ChestFindeItemView = require("lua.client.scene.ui.common.ChestFindeItemView"),
            HeroForHireItem = require("lua.client.scene.ui.home.uiHeroForHire.UIHeroForHireItem"),
            UIHeroLinkingItemView = require("lua.client.scene.ui.common.UIHeroLinkingItemView"),
            UIHeroLinkingCardRequireItemView = require("lua.client.scene.ui.common.UIHeroLinkingCardRequireItemView"),
            UIHeroLinkingItemSelectView = require("lua.client.scene.ui.common.UIHeroLinkingItemSelectView"),
            PlayerHeroIconView = require("lua.client.scene.ui.common.PlayerHeroIconView"),
            UILunarBossChapterItemView = require("lua.client.scene.ui.home.uiEventLunarPath.uiEventLunarPathLayout.uiEventLunarBossLayout.UILunarBossChapterItemView"),
            DailyRewardValentineView = require ("lua.client.scene.ui.home.uiEventValentine.eventLayout.dailyCheckin.DailyRewardValentineView"),
            ItemWithNameInfoView = require ("lua.client.scene.ui.common.ItemWithNameInfoView"),
            UIDefensePlayerRecordItem = require("lua.client.scene.ui.home.uiDefenseStageRecordList.UIDefensePlayerRecordItem"),
            ArenaTeamLogItem = require("lua.client.scene.ui.home.uiArenaTeamLog.ArenaTeamLogItem"),
            UIArenaTeamFormationItemView = require("lua.client.scene.ui.home.uiFormationArenaTeam.UIArenaTeamFormationItemView"),
            RoundRewardItem = require("lua.client.scene.ui.home.uiEventNewHero.RoundRewardItem"),
            UIPointSummonNewHeroItemView = require("lua.client.scene.ui.common.UIPointSummonNewHeroItemView"),
            DailyRewardMergeServerView = require ("lua.client.scene.ui.home.uiEventMergeServer.UIEventMergeServerLayout.dailyCheckin.DailyRewardMergeServerView"),
            LimitedBundleItemView = require("lua.client.scene.ui.common.LimitedBundleItemView"),
            DailyRewardEasterEggView = require("lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggLayout.dailyCheckin.DailyRewardEasterEggView"),
            UIEggCombineItemView = require("lua.client.scene.ui.common.UIEggCombineItemView"),
            UITreasureItemInfoView = require("lua.client.scene.ui.common.UITreasureItemInfoView"),
            DailyRewardWelcomeBackView = require("lua.client.scene.ui.home.uiWelcomeBack.WelcomeBackLoginLayout.DailyRewardWelcomeBackView"),
            DailyRewardEventBirthdayView = require("lua.client.scene.ui.home.uiEventBirthday.layout.dailyCheckin.DailyRewardEventBirthdayView"),
            ExchangeMultiItemView = require("lua.client.scene.ui.home.uiEventBirthday.layout.exchange.ExchangeMultiItemView"),
            IapSkinBundlePackItem = require("lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapSkinBundlePackItem"),
            IapSkinBundleHotPackItem = require("lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapSkinBundleHotPackItem"),
            IapIdleEffectBundlePackItem = require("lua.client.scene.ui.common.IdleEffectBundleItemView"),
            SimpleButtonView = require("lua.client.scene.ui.common.SimpleButtonView"),
            ItemDailySubscriptionView = require("lua.client.scene.ui.common.ItemDailySubscriptionView"),
            UIGuildWarRewardItemView = require("lua.client.scene.ui.home.uiGuildWarReward.UIGuildWarRewardItemView"),
            UIMembersItemView = require("lua.client.scene.ui.home.uiGuildMembersItem.UIGuildMembersItemView"),
            FlashSalePackageTabItem = require("lua.client.scene.ui.home.uiFlashSale.UIFlashSalePackageTabItem"),
            FlashSaleNewPackageTabItem = require("lua.client.scene.ui.home.uiFlashSaleNew.UIFlashSaleNewPackageTabItem"),
            UIBattlePassRewardItemView = require("lua.client.scene.ui.common.UIBattlePassRewardItemView"),
			UIArenaBootCampLeaderBoardItem = require("lua.client.scene.ui.common.ArenaBootCampLeaderBoardItemView"),
            PuzzleSlotItem = require("lua.client.scene.ui.common.PuzzleSlotItemView"),
            KazetsuBossLeaderBoardItemView = require("lua.client.scene.ui.home.uiEventKazetsu.eventLayout.KazetsuBoss.KazetsuBossLeaderBoardItemView"),
            BirthdayBossLeaderBoardItemView = require("lua.client.scene.ui.home.uiEventBirthday.layout.BirthdayBoss.BirthdayBossLeaderBoardItemView"),
            UIEventNewServerWeekQuestItem = require("lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventVipTreasure.UIEventNewServerWeekQuestItem"),
            UIEventPuzzleQuestItem = require("lua.client.scene.ui.home.uiEventPuzzle.eventLayout.puzzleQuest.UIEventPuzzleQuestItem"),
            UIEventNewVipQuestItem = require("lua.client.scene.ui.home.uiEventNewVip.quest.UIEventNewVipQuestItem"),
            UIEventZodiacQuestItem = require("lua.client.scene.ui.home.uiEventZodiac.layout.quest.UIEventZodiacQuestItem"),
            UIEventAiryuuQuestItem = require("lua.client.scene.ui.home.uiEventAiryuu.layout.quest.UIEventAiryuuQuestItem"),
            UIEventTowerOfEitriExchangeTitle = require("lua.client.scene.ui.home.uiEventTowerOfEitri.layout.exchange.TowerOfEitriExchangeTitleView"),
            UIEventTowerOfEitriExchangeItem = require("lua.client.scene.ui.home.uiEventTowerOfEitri.layout.exchange.TowerOfEitriExchangeItemView"),
            UIEventTowerOfEitriQuestItem = require("lua.client.scene.ui.home.uiEventTowerOfEitri.layout.quest.UIEventTowerOfEitriQuestItem"),
            UIEventBossChallengeQuestItem = require("lua.client.scene.ui.home.uiEventBossChallenge.eventLayout.quest.UIEventBossChallengeQuestItem"),
            UIEventHalloweenQuestItem = require("lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventQuest.UIEventHalloweenQuestItem"),
            UIEventTowerOfEitriQuestItemBanner = require("lua.client.scene.ui.home.uiEventTowerOfEitri.layout.quest.UIEventTowerOfEitriQuestItemBanner"),
            UIEventAiryuuEvolutionQuestItem = require("lua.client.scene.ui.home.uiEventAiryuu.layout.evolution.UIEventAiryuuEvolutionQuestItem"),
            UIEventMidAutumnQuestItem = require("lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.quest.UIEventMidAutumnQuestItem"),
            UIEventMidAutumnArenaItem = require("lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.midAutumnArena.UIEventMidAutumnArenaItem"),
            UIEventChristmasArenaItem = require("lua.client.scene.ui.home.uiEventChristmas.eventLayout.christmasArena.UIEventChristmasArenaItem"),
            UIEventZodiacCompletedQuestItem = require("lua.client.scene.ui.home.uiEventZodiac.layout.quest.UIEventZodiacCompletedQuestItem"),
            ServerWeekBundleItemView = require("lua.client.scene.ui.common.ServerWeekBundleItemView"),
            ServerWeekBundleItem2View = require("lua.client.scene.ui.common.ServerWeekBundleItem2View"),
            ServerWeekBundleItem3View = require("lua.client.scene.ui.common.ServerWeekBundleItem3View"),
            LineupItemView = require("lua.client.scene.ui.common.LineupItemView"),
            LineupItemView2 = require("lua.client.scene.ui.common.LineupItemView2"),
            LineupBossChallengeItemView = require("lua.client.scene.ui.common.LineupBossChallengeItemView"),
            VipBenefitDetailView = require("lua.client.scene.ui.common.VipBenefitDetailView"),
            ButtonVipTabView = require("lua.client.scene.ui.common.ButtonVipTabView"),
            KazetsuTowerTrailItem = require("lua.client.scene.ui.home.uiEventKazetsu.eventLayout.KazetsuTrail.KazetsuTowerTrailItem"),
            BossChallengeTowerItem = require("lua.client.scene.ui.home.uiEventBossChallenge.eventLayout.challenge_tower.BossChallengeTowerItem"),
            UIEventBossChallengeShopTitle = require("lua.client.scene.ui.home.uiEventBossChallenge.eventLayout.shop.BossChallengeShopTitleView"),
            UIEventPieceAdventureShopTitle = require("lua.client.scene.ui.home.uiEventPieceAdventure.uiEventPieceAdventureLayout.Shop.PieceAdventureShopTitleView"),
            UICustomPackView = require("lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopCustomizeBundleLayout.UICustomPackView"),
            UIEventBlackFridayNewPackView = require("lua.client.scene.ui.home.uiEventBlackFridayNewVersion.eventLayout.super_deal_layout.UIEventBlackFridayNewPackView"),
            UIEventBlackFridayNewCustomPackView = require("lua.client.scene.ui.home.uiEventBlackFridayNewVersion.eventLayout.select_item_layout.UIEventBlackFridayNewCustomPackView"),
            PreviewHeroSimpleView = require("lua.client.scene.ui.common.PreviewHeroSimpleView"),
            ExclusiveBundleButtonView = require("lua.client.scene.ui.common.ExclusiveBundleButtonView"),
            UIEventSkinChallengeNodeView = require("lua.client.scene.ui.home.uiEventSkinChallenge.layout.questLayout.SkinChallengeNodeView"),
            ProgressBarView = require("lua.client.scene.ui.common.ProgressBarView"),
            ProgressBarSectionHorizontal = require("lua.client.scene.ui.common.ProgressBarSectionHorizontal"),
            SectionRewardHorizontal = require("lua.client.scene.ui.common.SectionRewardHorizontal"),
            --BattlePassTabItem = require("lua.client.scene.ui.home.uiBattlePass.UIBattlePassWeeklyQuestTabItemView"),
            --UIStarterPackRewardView = require("lua.client.scene.ui.home.uiStarterPackNew.UIStarterPackRewardView"),
            --- GameObject
            NullObject = 'root_info',
            Mask = 'mask',
            MaskSelected = 'mask_selected',
            SkillSelected = 'skill_selected',
            TickSelected = 'tick_selected',
            MaskClose = 'mask_close',
            MaskLock = 'mask_lock',
            MaskLockMini = 'mask_lock_mini',
            Add = 'add',
            Rate = 'rate',
            FrameEffect = 'frame_effect',
            EffectSelected = 'effect_selected',
            NotificationItem = 'notification_item',
            TimeCountDown = 'time_count_down',
            FrameBoss = 'frame_boss',
            SoftTut = 'soft_tut',
            HpBar = 'hp_bar',
            BorderTalent = 'border_talent',
            MarkLimitedTime = "mark_limited_time",
            CornerSelect = 'corner_select',
            Plus = 'plus',
            Noti = 'noti',
            FXReward = 'fx_reward',
            Change = 'icon_change',
            Artifact = 'artifact',
            IconItemSlot = 'icon_item_slot',
            FrameRandom = 'frame_random',
        }
    end

    local function RequireGeneralEffectPoolType()
        local type = {
            BattleTextLog = require("lua.client.scene.ui.battle.uiBattleTextLog.UIBattleTextLog"),
            ClientEffect = require("lua.client.battleShow.ClientEffect.ClientEffect"),
            BattleEffectIcon = require("lua.client.scene.ui.battle.uiHeroStatusBar.UIBattleEffectIcon"),
            BattleMarkIcon = require("lua.client.scene.ui.battle.uiHeroStatusBar.UIBattleMarkIcon"),
            SpineClientEffect = require("lua.client.battleShow.ClientEffect.SpineClientEffect"),
        }
        GeneralEffectPoolType = type
    end

    local function RequireHeroEffectPoolType()
        local type = {
            ClientEffect = GeneralEffectPoolType.ClientEffect,
            SpineClientEffect = GeneralEffectPoolType.SpineClientEffect
        }
        HeroEffectPoolType = type
    end

    RequireUIPoolType()
    RequireGeneralEffectPoolType()
    RequireHeroEffectPoolType()
end

function RequireUIView()
    require "lua.client.scene.ui.utils.UIObjectList"
    require "lua.client.scene.ui.utils.uiSelect.UISelect"
    require "lua.client.scene.ui.utils.ToggleView"
    --require "lua.client.scene.ui.common.UITabConfig"
    --require "lua.client.scene.ui.common.UITabPopupConfig"
    require "lua.client.scene.ui.utils.UILoopScroll"
    require "lua.client.scene.ui.utils.UILoopScrollAsync"
    require "lua.client.scene.ui.common.heroList.HeroListView"
    require "lua.client.scene.ui.common.ItemsTableView"
    require "lua.client.scene.ui.common.UIInputView"
    require "lua.client.scene.ui.common.ListSkillView"
    require "lua.client.scene.ui.common.MoneyBarLocalView"
    require "lua.client.scene.ui.common.PreviewHero"
    require "lua.client.scene.ui.common.UIEventBigBundleItem"
end

RequireBase()
RequireSmartPool()
RequireUIView()
