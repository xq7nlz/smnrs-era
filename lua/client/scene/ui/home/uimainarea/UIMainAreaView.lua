require "lua.client.scene.ui.home.uiMainArea.mainAreaWorld.MainAreaWorld"
require "lua.client.scene.ui.home.uiTutorial.TutorialData"
require "lua.client.scene.ui.home.uiMiniQuestTree.UIMiniQuestTreeView"
require "lua.client.scene.ui.notification.NotificationFragment"
require "lua.client.utils.NotificationCheckUtils"
require "lua.client.scene.ui.home.uiEventBirthday.layout.UIEventBirthdayLayout"

IsLoadedBattlePass = false
--- @class UIMainAreaView : UIBaseView
UIMainAreaView = Class(UIMainAreaView, UIBaseView)

--- @param model UIMainAreaModel
function UIMainAreaView:Ctor(model)
    --- @type MainAreaWorld
    self.mainAreaWorld = nil
    --- @type UIMainAreaConfig
    self.config = nil
    --- @type MoneyBarView
    self.goldBarView = nil
    --- @type MoneyBarView
    self.gemBarView = nil
    --- @type VipIconView
    self.iconVip = nil
    --- @type UIMiniQuestTreeView
    self.uiMiniQuestTreeView = nil

    --- @type number
    self.timeServerOpen = nil

    self.updateTimeServerOpen = nil

    ---@type boolean
    self.isShowBundle = true
    UIBaseView.Ctor(self, model)
    --- @type UIMainAreaModel
    self.model = model
    --- @type boolean
    self.canShowEventPopup = true
end

function UIMainAreaView:OnReadyCreate()
    ---@type UIMainAreaConfig
    self.config = UIBaseConfig(self.uiTransform)

    self.config.gameObject:SetActive(false)
    self.mainAreaWorld = MainAreaWorld(self.config.mainAreaWorld, self)
    self:SetButtonFakeState()
    self:_InitButtonListener()
    self:_InitTimeCountDown()
    self:SetStateBundleDropDownArrow()
end

function UIMainAreaView:SetButtonFakeState()
    self.config.iconCheat.gameObject:SetActive(zgUnity.IsTest)
end

function UIMainAreaView:_InitTimeCountDown()
    self.updateTimeServerOpen = function(isSetTime)
        if isSetTime == true then
            --- @type ServerOpenInBound
            local eventData = zg.playerData:GetMethod(PlayerDataMethod.SERVER_OPEN)
            if eventData ~= nil and eventData.hasData then
                self.timeServerOpen = eventData.startTime + (eventData.numberOfDays * TimeUtils.SecondADay) - zg.timeMgr:GetServerTime()
            else
                self:RemoveTimeUpdate()
                return
            end
        else
            self.timeServerOpen = self.timeServerOpen - 1
        end

        if self.timeServerOpen >= TimeUtils.SecondADay then
            self.config.timeServerOpen.text = UIUtils.SetColorString(UIUtils.green_light,
                    string.format("%s %s", math.floor(self.timeServerOpen / TimeUtils.SecondADay), LanguageUtils.LocalizeCommon("day")))
        else
            self.config.timeServerOpen.text = UIUtils.SetColorString(UIUtils.red_light, TimeUtils.SecondsToClock(self.timeServerOpen))
        end
        if self.timeServerOpen < 0 then
            self:RemoveTimeUpdate()
        end
    end
end

--- @return void
function UIMainAreaView:InitLocalization()
    self.config.localizeDailyCheckin.text = LanguageUtils.LocalizeCommon("daily_checkin")
    self.config.localizeFriend.text = LanguageUtils.LocalizeCommon("friend")
    self.config.localizeMail.text = LanguageUtils.LocalizeCommon("mail")
    self.config.localizeShop.text = LanguageUtils.LocalizeCommon("shop")
    self.config.localizeWiki.text = LanguageUtils.LocalizeCommon("wiki")
    self.config.localizeWiki2.text = LanguageUtils.LocalizeCommon("community")
    self.config.localizeMainCharacter.text = LanguageUtils.LocalizeCommon("main_character")
    self.config.localizeMastery.text = LanguageUtils.LocalizeCommon("mastery")
    self.config.localizeInventory.text = LanguageUtils.LocalizeCommon("inventory")
    self.config.localizeHeroList.text = LanguageUtils.LocalizeCommon("hero_list")
    self.config.localizeQuest.text = LanguageUtils.LocalizeCommon("quest")
    self.config.localizeFreeGem.text = LanguageUtils.LocalizeCommon("free_gem")
    self.config.localizeHandOfMidas.text = LanguageUtils.LocalizeCommon("gold_mine")
    self.config.localizeFirstPurchase.text = LanguageUtils.LocalizeCommon("first_purchase")
    --if IS_APPLE_REVIEW_IAP then
    --    self.config.localizeFirstPurchase1.text = LanguageUtils.LocalizeCommon("first_purchase")
    --    self.config.localizeFirstPurchase2.text = LanguageUtils.LocalizeCommon("first_purchase")
    --    self.config.localizeFirstPurchase3.text = LanguageUtils.LocalizeCommon("first_purchase")
    --end
    --self.config.localizeHiddenDeal.text = LanguageUtils.LocalizeCommon("hidden_deal")
    self.config.localizeHiddenDeal.text = LanguageUtils.LocalizeCommon("flash_sale")
    self.config.text1stReward.text = LanguageUtils.LocalizeCommon("first_time_reward")
    self.config.localizeStarterPack.text = LanguageUtils.LocalizeCommon("starter_pack")
    self.config.localizeEventServerOpen.text = LanguageUtils.LocalizeCommon("server_open")
    self.config.textHalloween.text = LanguageUtils.LocalizeCommon("hallo_ween")
    self.config.textXmas.text = LanguageUtils.LocalizeCommon("xmas")
    self.config.textNewYear.text = LanguageUtils.LocalizeCommon("happy_new_year")
    self.config.textLunarNewYear.text = LanguageUtils.LocalizeCommon("lunar_new_year")
    self.config.textBlackFriday.text = LanguageUtils.LocalizeCommon("black_friday")
    self.config.textSaleOff.text = LanguageUtils.LocalizeCommon("sale_off")
    self.config.textLunarPath.text = LanguageUtils.LocalizeCommon("lunar_new_year_path")
    self.config.textValentine.text = LanguageUtils.LocalizeCommon("valentine")
    self.config.textEventNewHeroSummon.text = LanguageUtils.LocalizeCommon("new_hero_summon")
    self.config.textRaiseLevel.text = LanguageUtils.LocalizeFeature(FeatureType.RAISE_LEVEL)
    self.config.textEventNewHero.text = LanguageUtils.LocalizeCommon("new_hero")
    self.config.textEventMergeServer.text = LanguageUtils.LocalizeCommon("event_merge_server")
    self.config.textEventEasterEgg.text = LanguageUtils.LocalizeCommon("event_easter_egg")
    self.config.textWelcomeBack.text = LanguageUtils.LocalizeCommon("welcome_back")
    self.config.textBirthday.text = LanguageUtils.LocalizeCommon("birthday")
    self.config.textSkinBundle.text = LanguageUtils.LocalizeCommon("skin_bundle")
    self.config.textMidAutumn.text = LanguageUtils.LocalizeCommon("event_mid_autumn")
    if self.config.textSpecialOffer then
        self.config.textSpecialOffer.text = LanguageUtils.LocalizeCommon("special_offer")
    end

    self.mainAreaWorld:InitLocalization()
    if self.uiMiniQuestTreeView ~= nil then
        self.uiMiniQuestTreeView:InitLocalization()
    end

    self.config.textBattlePass.text = LanguageUtils.LocalizeCommon("battle_pass")
    self.config.textNewServerWeek.text = LanguageUtils.LocalizeCommon("event_server_open")
    self.config.textNewServerWeekCheckin.text = LanguageUtils.LocalizeCommon("event_server_open_checkin")
    self.config.textNewServerWeek2.text = LanguageUtils.LocalizeCommon("event_server_open_2")
    self.config.textNewServerWeek3.text = LanguageUtils.LocalizeCommon("event_server_open_3")
    self.config.textIdleEffect.text = LanguageUtils.LocalizeCommon("bundle_idle_effect")
    self.config.textEventKazetsu.text = LanguageUtils.LocalizeCommon("event_kazetsu")
    self.config.textEventKazetsuSummon.text = LanguageUtils.LocalizeCommon("event_kazetsu_rate_up")
    self.config.textEventFindeBoss.text = LanguageUtils.LocalizeCommon("event_finde_boss")
    self.config.textEventPuzzle.text = LanguageUtils.LocalizeCommon("event_puzzle")
    self.config.textEventZodiac.text = LanguageUtils.LocalizeCommon("event_zodiac")
    self.config.textEventSkinChallenge.text = LanguageUtils.LocalizeCommon("event_skin_challenge")
    self.config.textEventNewVip.text = LanguageUtils.LocalizeCommon("event_vip_treasure")
    self.config.textEventAiryuu.text = LanguageUtils.LocalizeCommon("event_airyuu")
    self.config.textEventTowerOfEitri.text = LanguageUtils.LocalizeCommon("event_tower_of_eitri")
    self.config.textEventSeasonal.text = LanguageUtils.LocalizeCommon("event_seasonal")
    self.config.textEventBossChallenge.text = LanguageUtils.LocalizeCommon("event_boss_challenge")
    self.config.textEventBoostFirstPurchase.text = LanguageUtils.LocalizeCommon("event_boost_first_purchase")
    self.config.textEventPieceAdventure.text = LanguageUtils.LocalizeCommon("event_piece_adventure")
    self.config.textEventBlackFridayNewVersion.text = LanguageUtils.LocalizeCommon("event_black_friday_new_version")
    self.config.textEventThanksGiving.text = LanguageUtils.LocalizeCommon("event_thanks_giving")
    self.config.textEventChristmas.text = LanguageUtils.LocalizeCommon("event_christmas")
    self.config.textEventNewYear2023.text = LanguageUtils.LocalizeCommon("event_new_year_2023")
    self.config.textEventLunarNewYear2024.text = LanguageUtils.LocalizeCommon("event_lunar_new_year_2024")
    self.config.textEventValentine2024.text = LanguageUtils.LocalizeCommon("event_valentine_2024")
    self.config.textEventDailyQuestPass.text = LanguageUtils.LocalizeCommon("daily_quest_pass")
    self.config.textEventEasterDay.text = LanguageUtils.LocalizeCommon("event_easter_day")
    self.config.textEventSummerDay.text = LanguageUtils.LocalizeCommon("event_summer_day")
    self.config.textEventBlossomDay.text = LanguageUtils.LocalizeCommon("event_blossom_day")
    self.config.textEventQixiFestival.text = LanguageUtils.LocalizeCommon("event_qixi_festival")
    self.config.textEventMayDay.text = LanguageUtils.LocalizeCommon("event_may_day")
    --self.config.textEventFlashSaleEvolve.text = LanguageUtils.LocalizeCommon("event_flash_sale_evolve")
end

--- @return void
--- @param result table
function UIMainAreaView:Show(result)
    if PopupUtils.IsPopupShowing(UIPopupName.UILoading) then
        local subject
        subject = RxMgr.hideLoading:Subscribe(function()
            UIBaseView.Show(self, result)
            subject:Unsubscribe()
        end)
    else
        UIBaseView.Show(self, result)
    end
end

function UIMainAreaView:CanShowTutorial()
    return TutorialData.CanShowTutorial() and UIBaseView.tutorial == nil
end

--- @param result {isFromFlashSale}
function UIMainAreaView:OnReadyShow(result)
    self.result = result
    self.mainAreaWorld:OnShow()
    self:_InitListener()
    self:_InitMoneyBar()
    self:ShowAvatar()
    self:ShowVip()
    self:ShowExpBar()

    if zg.networkMgr.isConnected then
        if self:CanShowTutorial() then
            PopupMgr.ShowPopup(UIPopupName.UITutorial)
        end
        self.mainAreaWorld:CheckSoftTutCampaign()
        self.mainAreaWorld:CheckSoftTutTower()

        self:CheckNotification()
        self:CheckFeatureUnlockButton()
        self:CheckFocusTutorial()
        self:CheckEnableButtonPurchaseEvents()
        self:CheckActiveFirstTimeRewardBtn()
    end

    self:SetStateBundleDropDown()
    self:AutoClosePopupCampaign()
end

function UIMainAreaView:AutoClosePopupCampaign()
    if PopupUtils.IsPopupShowing(UIPopupName.UISelectMapPVE) then
        PopupMgr.HidePopup(UIPopupName.UISelectMapPVE)
    end
end

--- @return void
function UIMainAreaView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)

    ChatData.CheckSystemMessage()

    self:CheckAndInitTutorial()

    self:CheckVisualFeatureStateUpdated()

    self:CheckPopupMiniQuestTree()

    self:CheckNotificationOnFinishAnim()

    self:CheckAutoShowPopup()

    self:CheckEnableEventWelcomeBack()

    self:CheckNotificationDomains()

    self:CheckOpeningEventServerOpen()
end

function UIMainAreaView:CheckPopupMiniQuestTree()
    local questTreeDataInBound = zg.playerData:GetQuest().questTreeDataInBound
    if TutorialData.CanShowTutorial() or UIBaseView.tutorial ~= nil then
        questTreeDataInBound.isCollapsed = true
    end

    ---@param questUnitInBound QuestUnitInBound
    self:CheckOpenMiniQuestTree(questTreeDataInBound.isCollapsed, function(questUnitInBound)
        if questTreeDataInBound.isCollapsed == false then
            self.uiMiniQuestTreeView:OnClickExpand()
        end
        if self.callbackDoneDataQuest ~= nil then
            self.uiMiniQuestTreeView:OnClickExpand()
            ---@type TutorialInBound
            local tutorialInBound = zg.playerData:GetMethod(PlayerDataMethod.TUTORIAL)
            if tutorialInBound ~= nil then
                local isQuestTree = ResourceMgr.GetQuestConfig():GetQuestTreeTypeById(questUnitInBound.questId) == QuestType.SUMMON_HERO_BY_BASIC_SCROLL
                if isQuestTree == false or (questUnitInBound.questState ~= QuestState.DOING
                        and tutorialInBound.listStepTutComplete:IsContainValue(TutorialMiniQuestTree.stepId) == false
                        and UIBaseView.tutorial.currentTutorial.tutorialStepData.step == TutorialStep.CLICK_GO) then
                    UITutorialView.RequestTutorialSetStep(TutorialMiniQuestTree.stepId)

                    if questUnitInBound.questState ~= QuestState.DONE_REWARD_NOT_CLAIM
                            and tutorialInBound.listStepTutComplete:IsContainValue(TutorialMiniQuestComplete.stepId) == false then
                        UITutorialView.RequestTutorialSetStep(TutorialMiniQuestComplete.stepId)
                    end
                end

                if isQuestTree == false or (questUnitInBound.questState ~= QuestState.DONE_REWARD_NOT_CLAIM
                        and tutorialInBound.listStepTutComplete:IsContainValue(TutorialMiniQuestComplete.stepId) == false
                        and UIBaseView.tutorial.currentTutorial.tutorialStepData.step == TutorialStep.CLICK_QUEST_COMPLETE) then
                    UITutorialView.RequestTutorialSetStep(TutorialMiniQuestComplete.stepId)
                end
            end

            self.callbackDoneDataQuest = nil
            UIBaseView.tutorial:ShowTutorialCanRun()
            if self.callbackDoneDataQuest ~= nil then
                self.callbackDoneDataQuest()
                self.callbackDoneDataQuest = nil
            end
        end
    end)
end

--- @return void
function UIMainAreaView:_InitMoneyBar()

    if self.gemBarView == nil then
        self.gemBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.gemRoot)
    end
    self.gemBarView:AddListener(function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIIapShop, IapShopTab.RAW_PACK, UIPopupName.UIMainArea)
    end)
    self.gemBarView:SetIconData(MoneyType.GEM)
    self.gemBarView:Reverse(true)

    if self.goldBarView == nil then
        self.goldBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.goldRoot)
    end
    self.goldBarView:AddListener(function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIIapShop, IapShopTab.REGULAR_PACK, UIPopupName.UIMainArea)
    end)
    self.goldBarView:SetIconData(MoneyType.GOLD)
    self.goldBarView:Reverse(true)
end

function UIMainAreaView:OnReadyHide()
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("quit_game"), nil, function()
        U_Application.Quit()
    end, nil)
end

function UIMainAreaView:Hide()
    UIBaseView.Hide(self)
    self.callbackDoneDataQuest = nil

    self:RemoveListener()

    self:RemoveTimeUpdate()

    self:RemoveCheckNotificationCampaign()

    self:RemoveCheckNotificationSummon()

    if self.gemBarView then
        self.gemBarView:ReturnPool()
        self.gemBarView = nil
    end

    if self.goldBarView then
        self.goldBarView:ReturnPool()
        self.goldBarView = nil
    end

    if self.iconVip then
        self.iconVip:ReturnPool()
        self.iconVip = nil
    end

    self.mainAreaWorld:OnHide()
    if self.uiMiniQuestTreeView ~= nil and self.uiMiniQuestTreeView:IsActiveSelf() then
        self.uiMiniQuestTreeView:SetCollapseState(true)
    end

    if self.subscriptionNotiInventory ~= nil then
        self.subscriptionNotiInventory:Unsubscribe()
        self.subscriptionNotiInventory = nil
    end

    self.config.softTutInventory:SetActive(false)
end

--- @return void
function UIMainAreaView:_InitListener()


    self.listenerMail = RxMgr.notificationRequestMail
                             :Merge(RxMgr.notificationUiMail)
                             :Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationMail))

    self.listenerFriend = RxMgr.notificationRequestUiFriend
                               :Merge(RxMgr.notificationUiFriend)
                               :Merge(RxMgr.notificationRequestCommunityTotal)
                               :Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationFriend))

    self.listenerCommunity = RxMgr.notificationRequestCommunity
                                  :Merge(RxMgr.notificationRequestCommunityTotal)
                                  :Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationCommunity))

    self.listenerCommunityTotal = RxMgr.notificationRequestCommunityTotal:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationCommunityTotal))

    self.listenerDailyGift = RxMgr.notificationUiDailyReward:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationDailyGift))

    self.listenerRename = RxMgr.finishName:Subscribe(RxMgr.CreateFunction(self, self.CheckRename))

    self.listenerChangeAvatar = RxMgr.changeAvatar
                                     :Merge(RxMgr.levelUp)
                                     :Subscribe(RxMgr.CreateFunction(self, self.ShowAvatar))

    self.listenerQuest = RxMgr.notificationRequestQuest:Subscribe(RxMgr.CreateFunction(self, self.OnNotifiedQuestRequest))

    self.listenerPurchasePacks = RxMgr.notificationPurchasePacks:Subscribe(RxMgr.CreateFunction(self, self.OnPurchaseSuccess))

    self.listenerVideoRewarded = RxMgr.notificationVideoRewarded:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationVideoRewarded))

    self.listenToHideLoading = RxMgr.hideLoading:Subscribe(RxMgr.CreateFunction(self, self.OnHideLoading))

    self.listenerHandOfMidas = RxMgr.notificationHandOfMidas:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationHandOfMidas))

    self.listenerChatMessage = RxMgr.notificationUnreadChatMessage:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationChat))

    self.listenerNotiEventPopup = RxMgr.notificationEventPopup:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationEventPopup))

    self.listenerNotiEventIap = RxMgr.notificationEventIap:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationIapShop))

    self.listenerNotiChangeResource = RxMgr.changeResource:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationOnChangeResource))

    self.listenerShowFragment = RxMgr.changeResource:Subscribe(RxMgr.CreateFunction(self, self.CheckShowFragment))

    self.listenerFeatureUpdated = RxMgr.featureConfigUpdated:Subscribe(RxMgr.CreateFunction(self, self.CheckVisualFeatureStateUpdated))

    self.listenerWatchAds = RxMgr.notificationWatchAds:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationVideoRewarded))
end

--- @return void
function UIMainAreaView:RemoveListener()
    if self.listenerShowFragment then
        self.listenerShowFragment:Unsubscribe()
        self.listenerShowFragment = nil
    end
    if self.listenerMail then
        self.listenerMail:Unsubscribe()
        self.listenerMail = nil
    end
    if self.listenerFriend then
        self.listenerFriend:Unsubscribe()
        self.listenerFriend = nil
    end
    if self.listenerDailyGift then
        self.listenerDailyGift:Unsubscribe()
        self.listenerDailyGift = nil
    end
    if self.listenerRename then
        self.listenerRename:Unsubscribe()
        self.listenerRename = nil
    end
    if self.listenerChangeAvatar then
        self.listenerChangeAvatar:Unsubscribe()
        self.listenerChangeAvatar = nil
    end
    if self.listenerQuest then
        self.listenerQuest:Unsubscribe()
        self.listenerQuest = nil
    end
    if self.listenerChatMessage then
        self.listenerChatMessage:Unsubscribe()
        self.listenerChatMessage = nil
    end

    if self.listenerPurchasePacks then
        self.listenerPurchasePacks:Unsubscribe()
        self.listenerPurchasePacks = nil
    end

    if self.listenerHandOfMidas then
        self.listenerHandOfMidas:Unsubscribe()
        self.listenerHandOfMidas = nil
    end

    if self.listenerVideoRewarded then
        self.listenerVideoRewarded:Unsubscribe()
        self.listenerVideoRewarded = nil
    end

    if self.listenToHideLoading then
        self.listenToHideLoading:Unsubscribe()
        self.listenToHideLoading = nil
    end

    if self.listenerNotiEventPopup then
        self.listenerNotiEventPopup:Unsubscribe()
        self.listenerNotiEventPopup = nil
    end

    if self.listenerNotiEventIap then
        self.listenerNotiEventIap:Unsubscribe()
        self.listenerNotiEventIap = nil
    end

    if self.listenerNotiChangeResource then
        self.listenerNotiChangeResource:Unsubscribe()
        self.listenerNotiChangeResource = nil
    end

    if self.buyCompleteSub ~= nil then
        self.buyCompleteSub:Unsubscribe()
        self.buyCompleteSub = nil
    end

    if self.listenerFeatureUpdated ~= nil then
        self.listenerFeatureUpdated:Unsubscribe()
        self.listenerFeatureUpdated = nil
    end

    if self.listenerWatchAds ~= nil then
        self.listenerWatchAds:Unsubscribe()
        self.listenerWatchAds = nil
    end

    self:RemoveListenerTutorial()
end

function UIMainAreaView:CheckNotification()
    self:CheckNotificationModeShop()
    self:CheckNotificationCampaign()
    self:CheckNotificationRaid()
    self:CheckNotificationFriend()
    self:CheckNotificationVideoRewarded()
    self:CheckNotificationTavern()
    self:CheckNotificationSummoner()
    self:CheckNotificationRaiseLevelHero()
    self:CheckNotificationEventPopup()
    self:CheckFirstTimeRewardNoti()
    self:CheckStarterPackNoti()
    self:CheckNotificationCommunity()
    self:CheckNotificationCommunityTotal()
end

function UIMainAreaView:OnPurchaseSuccess()
    self:CheckEnableButtonPurchaseEvents()
end

--- @param viewType PackViewType
--- @param state boolean
function UIMainAreaView:SetProgressButtonStateByViewType(viewType, state)
    if viewType == PackViewType.STARTER_PACK_NEW then
        --XDebug.Log(" HOANGPL  set progressbtn " .. tostring(state))
        self.config.buttonStarterPack.gameObject:SetActive(state)
        if (state) then
            self:CheckStarterPackNoti()
        end
    elseif viewType == PackViewType.FLASH_SALE_PACK then
        self.config.btnFlashSale.gameObject:SetActive(state)
    elseif viewType == PackViewType.MASTER_BLACKSMITH and self.config.buttonSpecialOffer then
        self.config.buttonSpecialOffer.gameObject:SetActive(state)
    elseif viewType ~= PackViewType.FLASH_SALE_NEW and viewType ~= PackViewType.STARTER_PACK then
        XDebug.Log("View Type is not exist: " .. tostring(viewType))
    end
end

---@param iapDataInBound IapDataInBound
function UIMainAreaView:CheckShowNewFlashSaleBtn(iapDataInBound)
    local listAvailableFlashSaleNewPack = iapDataInBound.progressPackData:GetActiveGroupListNewFlashSale()
    local showFlashSaleBtn = listAvailableFlashSaleNewPack ~= nil and listAvailableFlashSaleNewPack:Count() > 0
    self.config.btnFlashSaleNew.gameObject:SetActive(showFlashSaleBtn)
    if showFlashSaleBtn then
        self.config.notifyFlashSaleNew:SetActive(NotificationCheckUtils.IsNewFlashSaleTabNotification())
    end
end

---@param iapDataInBound IapDataInBound
function UIMainAreaView:CheckShowFlashSaleBtn(iapDataInBound)
    local listAvailableFlashSalePack = iapDataInBound.progressPackData:GetActiveGroupListFlashSale()
    local showFlashSaleBtn = listAvailableFlashSalePack ~= nil and listAvailableFlashSalePack:Count() > 0
    self.config.btnFlashSale.gameObject:SetActive(showFlashSaleBtn)
    if showFlashSaleBtn then
        self.config.notifyFlashSale.gameObject:SetActive(NotificationCheckUtils.IsFlashSaleTabNotification())
    end
end

---@param iapDataInBound IapDataInBound
function UIMainAreaView:CheckShowBoostFirstPurchaseBtn(iapDataInBound)
    local group = iapDataInBound.boostFirstPurchaseCollection:GetActiveGroupBoostFirstPurchase()
    local showBoostFirstPurchaseBtn = false
    if group ~= 0 and group.listProductConfig ~= nil and group.listProductConfig:Count() > 0 then
        showBoostFirstPurchaseBtn = true
    end
    self.config.buttonBoostFirstPurchase.gameObject:SetActive(showBoostFirstPurchaseBtn)
end

---@param iapDataInBound IapDataInBound
function UIMainAreaView:CheckShowFlashSaleEvolveBtn(iapDataInBound)
    local showFlashSaleEvolveBtn = false
    ---@type List
    local listIdHero = iapDataInBound.GetFlashSaleEvolveActiveGroup():GetListIdHeroActive() > 0
    if listIdHero and listIdHero:Count() > 0 then
        showFlashSaleEvolveBtn = true
    end
    self.config.buttonFlashSaleEvolve.gameObject:SetActive(showFlashSaleEvolveBtn)
end

function UIMainAreaView:CheckEnableButtonPurchaseEvents()
    self:SetProgressButtonStateByViewType(PackViewType.STARTER_PACK_NEW, false)
    self:SetProgressButtonStateByViewType(PackViewType.MASTER_BLACKSMITH, false)

    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    self:CheckShowFlashSaleBtn(iapDataInBound)
    self:CheckShowNewFlashSaleBtn(iapDataInBound)
    self:CheckShowBoostFirstPurchaseBtn(iapDataInBound)
    --self:CheckShowFlashSaleEvolveBtn(iapDataInBound)

    local progressActiveGroupList = iapDataInBound.progressPackData:GetActiveGroupList()
    if progressActiveGroupList:Count() > 0 then
        --- @param v GroupProductConfig
        for _, v in ipairs(progressActiveGroupList:GetItems()) do
            self:SetProgressButtonStateByViewType(v.viewType, true)
        end
    end
    --local isEnable = iapDataInBound:CanShowButtonTrialMonthly()
    local isEnable = false
    self.config.trialMonthlyCard.gameObject:SetActive(isEnable)
end

function UIMainAreaView:CheckNotificationOnFinishAnim()
    self:CheckNotificationMail()
    self:CheckNotificationQuest()
    self:CheckNotificationChat()
    self:CheckNotificationInventory()
    self:CheckNotificationDailyGift()
    self:CheckNotificationHandOfMidas()
    self:CheckNotificationDefenseMode()
    self:CheckNotificationHeroLinking()
    self:CheckSoftTutHero()
    self:CheckNotificationCommunity()
    self:CheckNotificationFriend()
    self:CheckNotificationCommunityTotal()
end

function UIMainAreaView:CheckAutoShowPopup()
    if TutorialData.CanShowTutorial() or UIBaseView.tutorial ~= nil then
        return
    end
    Coroutine.start(function()
        coroutine.waitforseconds(0.2)
        if self.config.gameObject.activeInHierarchy == false then
            return
        end
        --- @type IapDataInBound
        local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
        --- @type RemoteConfigData
        local remoteConfigData = zg.playerData.remoteConfig
        --- @type List
        local listAutoShowPopup = List()
        local listPopupData = List()
        self:CheckAutoShowProgressPack(listAutoShowPopup, listPopupData, iapDataInBound, remoteConfigData)
        --self:CheckAutoShowTrial(iapDataInBound, listPopupData, listAutoShowPopup)
        self:CheckAutoShowBoostFirstPurchase(iapDataInBound, listAutoShowPopup, listPopupData)
        self:CheckAutoShowFlashSaleEvolve(iapDataInBound, listAutoShowPopup, listPopupData)
        self:CheckAutoShowNewSererWeekCheckIn(listAutoShowPopup, listPopupData, remoteConfigData)

        if listAutoShowPopup:Count() > 0 then
            UIBaseView.CheckBlurMain(true, true, function()
                self:_ShowListAutoShowPopupProgress(listAutoShowPopup, listPopupData)
            end)
        else
            self:CheckNotiBindingAccount()
        end
    end)
end

function UIMainAreaView:CheckAutoShowBlackFriday(listAutoShowPopup)
    local eventInBound = zg.playerData:GetEvents()
    if eventInBound ~= nil then
        --- @type EventBlackFridayModel
        local eventBlackFriday = eventInBound:GetEvent(EventTimeType.EVENT_BLACK_FRIDAY)
        if eventBlackFriday ~= nil then
            if eventBlackFriday:IsOpening() then
                if eventBlackFriday:IsAutoShow() then
                    listAutoShowPopup:Add(UIPopupName.UIEventBlackFriday)
                end
            else
                if eventBlackFriday:IsAutoShowValidDuration() then
                    listAutoShowPopup:Add(UIPopupName.UIEventBlackFriday)
                end
            end
        end
    end
    return listAutoShowPopup
end

function UIMainAreaView:CheckAutoShowLoginReward(listAutoShowPopup)
    local eventInBound = zg.playerData:GetEvents()
    if eventInBound ~= nil then
        --- @type EventPopupLoginModel
        local eventPopupLoginModel = eventInBound:GetEvent(EventTimeType.EVENT_LOGIN)
        if eventPopupLoginModel ~= nil
                and eventPopupLoginModel:IsAvailableToShowLogin() == true then
            listAutoShowPopup:Add(UIPopupName.UIEventLogin)
        end
    end
    return listAutoShowPopup
end

function UIMainAreaView:CheckAutoShowBoostFirstPurchase(iapDataInBound, listAutoShowPopup, listPopupData)
    local group = iapDataInBound.boostFirstPurchaseCollection:GetActiveGroupBoostFirstPurchase()
    local showBoostFirstPurchaseBtn = false
    if group ~= 0 and group.listProductConfig ~= nil and group.listProductConfig:Count() > 0 then
        showBoostFirstPurchaseBtn = true
    end
    if showBoostFirstPurchaseBtn and NotificationCheckUtils.IsBoostFirstPurchaseNotification() == true then
        listAutoShowPopup:Add(UIPopupName.UIBoostFirstPurchase)
        listPopupData:Add(false)
    end
end

---@param iapDataInBound IapDataInBound
function UIMainAreaView:CheckAutoShowFlashSaleEvolve(iapDataInBound, listAutoShowPopup, listPopupData)
    ---@type List
    local listIdHero = iapDataInBound.GetFlashSaleEvolveActiveGroup():GetListIdHeroActive()
    local isAutoShow = false
    if listIdHero and listIdHero:Count() > 0 then
        isAutoShow = true
    end
    if isAutoShow then
        listAutoShowPopup:Add(UIPopupName.UIFlashSaleEvolve)
        local data = {}
        data.listIdHero = listIdHero
        data.callbackClose = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIFlashSaleEvolve)
        end
        listPopupData:Add(data)
    end
end

function UIMainAreaView:CheckAutoShowNewSererWeekCheckIn(listAutoShowPopup, listPopupData, remoteConfigData)
    --- @type EventNewServerWeekModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK)
    local now = zg.timeMgr:GetServerTime()
    local nextLastSeenDay = remoteConfigData.newServerCheckinSeen
    if nextLastSeenDay == nil or nextLastSeenDay < now then
        if eventModel and eventModel.timeData:IsOpening() then
            listAutoShowPopup:Add(UIPopupName.UINewServerWeek)
            local data = {}
            data.tab = NewServerWeekTab.DAILY
            listPopupData:Add(data)
        end
    end
end

function UIMainAreaView:CheckAutoShowProgressPack(listAutoShowPopup, listPopupData, iapDataInBound, remoteConfigData)
    --- @type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    local lastTimeLogin = basicInfoInBound.lastLoginTime
    self:CheckShowNewFlashSaleBtn(iapDataInBound)
    local listActiveGroup = iapDataInBound.progressPackData:GetActiveGroupList()
    --- @param uiPopupName UIPopupName
    --- @param isNotShowMoreToday boolean
    --- @param groupProductConfig GroupProductConfig
    local checkAddPopup = function(uiPopupName, lastTimeLoginToShowPopup, groupProductConfig, isNotShowMoreToday)
        if lastTimeLoginToShowPopup ~= lastTimeLogin and isNotShowMoreToday == false then
            local listPack = groupProductConfig.listProductConfig
            for i = 1, listPack:Count() do
                --- @type ProductConfig
                local packConfig = listPack:Get(i)
                local boughtCount = iapDataInBound.progressPackData:GetBoughtCount(packConfig.id)
                if boughtCount < packConfig.stock and listAutoShowPopup:IsContainValue(uiPopupName) == false then
                    --print("Add Popup ", uiPopupName)
                    listAutoShowPopup:Add(uiPopupName)
                    listPopupData:Add(false)
                    break
                end
            end
        end
    end
    --- @param uiPopupName UIPopupName
    --- @param isNotShowMoreToday boolean
    local checkAddPopupEvent = function(uiPopupName, isNotShowMoreToday)
        --local groupId = groupProductConfig.groupId
        --local createdTime = iapDataInBound.progressPackData.activeProgressPackDict:Get(groupId)
        if isNotShowMoreToday == false then
            if listAutoShowPopup:IsContainValue(uiPopupName) == false then
                --print("Add Popup ", uiPopupName)
                listAutoShowPopup:Add(uiPopupName)
            end
        end
    end
    local isNotShowMoreToday = false
    if not iapDataInBound:HasClaimedAllFirstTopUPReward() and remoteConfigData.showedFirstTopUpLoginTime ~= basicInfoInBound.lastLoginTime then
        checkAddPopupEvent(UIPopupName.UIFirstTopUp, isNotShowMoreToday)
    end
    for i = 1, listActiveGroup:Count() do
        --- @type GroupProductConfig
        local groupProductConfig = listActiveGroup:Get(i)
        --XDebug.Log("VIEW TYPE HOANGPL " .. tostring(groupProductConfig.viewType))
        if groupProductConfig.autoShow == true then
            if groupProductConfig.viewType == PackViewType.STARTER_PACK_NEW then
                -- XDebug.Log(" HOANGPL CHECK ADD POPUP STARTER PACK NEW")
                checkAddPopup(UIPopupName.UIStarterPackNew, remoteConfigData.showedStarterPackLoginTime, groupProductConfig, isNotShowMoreToday)
                --[[                    elseif groupProductConfig.viewType == PackViewType.FIRST_TIME_PACK then
                                        checkAddPopup(UIPopupName.UIFirstPurchase, remoteConfigData.showedFirstPurchaseLoginTime, groupProductConfig, isNotShowMoreToday)
                                        --elseif groupProductConfig.viewType == PackViewType.FLASH_SALE_PACK then
                                        --    checkAddPopup(UIPopupName.UIHiddenDeal, remoteConfigData.showedFlashSaleLoginTime, groupProductConfig, isNotShowMoreToday)]]
            elseif groupProductConfig.viewType == PackViewType.MASTER_BLACKSMITH then
                checkAddPopup(UIPopupName.UISpecialOfferShop, remoteConfigData.showedMasterBlackSmithLoginTime, groupProductConfig, isNotShowMoreToday)
            elseif groupProductConfig.viewType == PackViewType.FLASH_SALE_PACK then
                --checkAddPopup(UIPopupName.UIFlashSale, remoteConfigData.showedFlashSaleLoginTime, groupProductConfig, isNotShowMoreToday)
                if NotificationCheckUtils.IsFlashSaleTabNotification() == true then
                    if self.result == nil or self.result.isFromFlashSale ~= true then
                        listAutoShowPopup:Add(UIPopupName.UIFlashSale)
                    end
                end
            elseif groupProductConfig.viewType == PackViewType.FLASH_SALE_NEW then
                if NotificationCheckUtils.IsNewFlashSaleTabNotification() == true then
                    if self.result == nil or self.result.isFromFlashSale ~= true then
                        listAutoShowPopup:Add(UIPopupName.UIFlashSaleNew)
                    end
                end
            end
        end
    end
    local EventDatas = zg.playerData:GetEvents()
    if self.canShowEventPopup == true then
        for eventTimeType, eventPopupModel in pairs(EventDatas:GetAllEvents():GetItems()) do
            if eventPopupModel:IsOpening() then
                local now = zg.timeMgr:GetServerTime()
                if eventTimeType == EventTimeType.EVENT_HALLOWEEN and (remoteConfigData.showedEventHalloweenTime == nil or remoteConfigData.showedEventHalloweenTime <= now) then
                    checkAddPopupEvent(UIPopupName.UIEventHalloween, isNotShowMoreToday)
                    break
                elseif eventTimeType == EventTimeType.EVENT_MID_AUTUMN and (remoteConfigData.showedEventAutumnTime == nil or remoteConfigData.showedEventAutumnTime <= now) then
                    checkAddPopupEvent(UIPopupName.UIEventMidAutumn, isNotShowMoreToday)
                    break
                elseif eventTimeType == EventTimeType.EVENT_HERO_RELEASE and (remoteConfigData.showedEvenReleaseHeroTime == nil or remoteConfigData.showedEvenReleaseHeroTime <= now) then
                    checkAddPopupEvent(UIPopupName.UIEventHeroRelease, isNotShowMoreToday)
                    break
                elseif eventTimeType == EventTimeType.EVENT_LOGIN and
                        (remoteConfigData.showedEvenLoginTime == nil or
                                remoteConfigData.showedEvenLoginTime <= now) then
                    checkAddPopupEvent(UIPopupName.UIEventLogin, isNotShowMoreToday)
                    break
                elseif eventTimeType == EventTimeType.EVENT_XMAS and (remoteConfigData.showedEvenXmasTime == nil or remoteConfigData.showedEvenXmasTime <= now) then
                    checkAddPopupEvent(UIPopupName.UIEventXmas, isNotShowMoreToday)
                    break
                elseif eventTimeType == EventTimeType.EVENT_BLACK_FRIDAY and (remoteConfigData.showedEvenBlackFridayTime == nil or remoteConfigData.showedEvenBlackFridayTime <= now) then
                    checkAddPopupEvent(UIPopupName.UIEventBlackFriday, isNotShowMoreToday)
                    break
                elseif eventTimeType == EventTimeType.EVENT_KAZETSU and (remoteConfigData.showedEventKazetsuTime == nil or remoteConfigData.showedEventKazetsuTime <= now) then
                    if isNotShowMoreToday == false then
                        if listAutoShowPopup:IsContainValue(UIPopupName.UIIntroduceNewSkin) == false then
                            listAutoShowPopup:Insert(UIPopupName.UIIntroduceNewSkin, 0)
                        end
                    end
                    break
                end
            else
                self.canShowEventPopup = true
            end
        end
    end
end

---@param iapDataInBound IapDataInBound
function UIMainAreaView:CheckAutoShowTrial(iapDataInBound, listPopupData, listAutoShowPopup)
    if iapDataInBound:CheckAutoShowTrialMonthly()
            and iapDataInBound:CanShowButtonTrialMonthly() then
        listAutoShowPopup:Add(UIPopupName.UITrialMonthlyCard)
        listPopupData:Add(false)
    end
end

--- @param listAutoShowPopup List
function UIMainAreaView:_ShowListAutoShowPopupProgress(listAutoShowPopup, listPopupData)
    local popup = listAutoShowPopup:Get(1)
    local data = listPopupData:Get(1)
    if not data then
        data = {}
    end
    local popupData = data
    popupData.callbackClose = function()
        listAutoShowPopup:RemoveByIndex(1)
        if PopupUtils.IsPopupShowing(popup) then
            PopupMgr.HidePopup(popup)
        end
        self:_ShowListAutoShowPopupProgress(listAutoShowPopup, listPopupData)
    end
    if listAutoShowPopup:Count() > 1 then
        self.canShowEventPopup = false
        PopupMgr.ShowPopup(popup, popupData)
    elseif listAutoShowPopup:Count() == 1 then
        listAutoShowPopup:RemoveByIndex(1)
        self.canShowEventPopup = false
        popupData.callbackClose = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, popupData, popup)
        end
        PopupMgr.ShowPopup(popup, data)
    end
end

function UIMainAreaView:RunTimeUpdate()
    ---@type HandOfMidasInBound
    local handOfMidas = zg.playerData:GetMethod(PlayerDataMethod.HAND_OF_MIDAS)
    if handOfMidas == nil then
        return
    end
    handOfMidas:SetTimeRefresh()
    if handOfMidas:CanRefresh() then
        handOfMidas:ResetClaimDict()
    else
        handOfMidas:StartRefreshTime()
    end
end

function UIMainAreaView:RemoveTimeUpdate()
    if self.updateTimeServerOpen then
        zg.timeMgr:RemoveUpdateFunction(self.updateTimeServerOpen)
    end
end

--- @return void
function UIMainAreaView:CheckNotificationMail()
    --- @type MailDataInBound
    local mailData = zg.playerData:GetMethod(PlayerDataMethod.MAIL)
    if mailData ~= nil then
        self.config.notiMail:SetActive(mailData:IsActiveNotification())
    end
end

--- @return void
function UIMainAreaView:CheckNotificationSummoner()
    --- @type PlayerSummonerInBound
    local summonerInBound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    if summonerInBound ~= nil then
        self.config.notiSummoner:SetActive(summonerInBound:IsNotiEvolve())
    end
end
--- @return void
function UIMainAreaView:CheckNotificationRaiseLevelHero()
    --- @type PlayerRaiseLevelInbound
    local raiseInbound = zg.playerData:GetRaiseLevelHero()
    if raiseInbound ~= nil then
        local _noti = raiseInbound:CheckNotificationInMain()
        self.config.notiRaiseHero:SetActive(_noti)
    end
end
--- @return void
function UIMainAreaView:CheckNotificationIapShop()
    self.config.notifyShop:SetActive(false)
    local isNotified = false

    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetIAP()
    --- @type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    --- @type GrowthPackCollection
    local growthPackCollection = iapDataInBound.growthPackData

    EventInBound.ValidateEventModel(function()
        --- @type EventInBound
        local eventInBound = zg.playerData:GetEvents()
        local hasOpeningEvent = eventInBound ~= nil and eventInBound:IsOpeningEventIap()
        local hasNotification = eventInBound:HasNotificationEventIap()
        isNotified = hasOpeningEvent and hasNotification
        self.config.notifyShop:SetActive(isNotified)
        if isNotified == false then
            local isDailyEvent = false
            if isNotified == false and EventInBound.IsEventOpening(EventTimeType.EVENT_HALLOWEEN) then
                isDailyEvent = true
                isNotified = ResourceMgr.GetPurchaseConfig():GetHalloweenDaily():IsNotificationDailyDeal()
            end
            if isNotified == false and EventInBound.IsEventOpening(EventTimeType.EVENT_XMAS) then
                isDailyEvent = true
                isNotified = ResourceMgr.GetPurchaseConfig():GetXmasDaily():IsNotificationDailyDeal()
            end
            if isNotified == false and EventInBound.IsEventOpening(EventTimeType.EVENT_NEW_YEAR) then
                isDailyEvent = true
                isNotified = ResourceMgr.GetPurchaseConfig():GetNewYearBundle():IsNotificationDailyDeal()
            end
            if isDailyEvent == false then
                isNotified = ResourceMgr.GetPurchaseConfig():GetCashShop():IsNotificationDailyDeal()
            end
            self.config.notifyShop:SetActive(isNotified)
            if isNotified == false then
                --- @param growthPackLineConfig GrowthPackLineConfig
                local checkActiveNotify = function(growthPackLineConfig)
                    if growthPackLineConfig == nil then
                        return false
                    end
                    local claimAbleMilestone = growthPackLineConfig:GetClaimableMilestone(basicInfoInBound.level,
                            growthPackCollection:GetBoughtCount(growthPackLineConfig.line) > 0,
                            growthPackCollection:GetGrowPatchLine(growthPackLineConfig.line))
                    if claimAbleMilestone ~= nil then
                        self.config.notifyShop:SetActive(isNotified)
                    end
                    return claimAbleMilestone ~= nil
                end
                --- @type GrowthPackLineConfig
                local growthPackLine1 = ResourceMgr.GetLevelPassConfig():GetGrowthPackConfigByLine(1)
                if checkActiveNotify(growthPackLine1) then
                    return
                end
                --- @type GrowthPackLineConfig
                local growthPackLine2 = ResourceMgr.GetLevelPassConfig():GetGrowthPackConfigByLine(2)
                checkActiveNotify(growthPackLine2)
            end
        end
    end, nil, false, false)
end

--- @return void
function UIMainAreaView:CheckNotificationFriend()
    --- @type PlayerFriendInBound
    local friendData = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    if friendData then
        --self.config.nofiFriend:SetActive(friendData:IsActiveNotification())
        self.config.notiWiki2.gameObject:SetActive(friendData:IsActiveNotification())
    end
end

--- @return void
function UIMainAreaView:CheckNotificationCommunityTotal()
    local friendNoti
    local communityNoti
    local eventNoti
    --- @type PlayerFriendInBound
    local friendData = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)
    if friendData then
        friendNoti = friendData:IsActiveNotification()
    end
    local eventInBound = zg.playerData:GetEvents().eventCommunityInBound
    if eventInBound then
        communityNoti = eventInBound:HasNotification()
    end
    --- @type CommunityEventData
    local communityEventData = zg.playerData:GetEvents().communityEventData
    if communityEventData then
        eventNoti = communityEventData:HasEventTabNotSeen()
    end
    self.config.notiWiki2.gameObject:SetActive(friendNoti or communityNoti or eventNoti)
end

--- @return void
function UIMainAreaView:CheckNotificationCommunity()
    local validateEventModel = Job(function(onSuccess, _)
        EventInBound.ValidateEventModel(onSuccess)
    end)
    local validateEventCommunity = Job(function(onSuccess, _)
        EventCommunityInBound.ValidateData(onSuccess)
    end)
    local doneValidate = function()
        ---@type EventCommunityInBound
        local eventInBound = zg.playerData:GetEvents().eventCommunityInBound
        if eventInBound then
            self.config.notiWiki2.gameObject:SetActive(eventInBound:HasNotification())
        end
    end
    --- @type Job
    local jobMultiple = validateEventModel + validateEventCommunity
    jobMultiple:Complete(doneValidate)

    ---@type EventCommunityInBound
    --local eventInBound = zg.playerData:GetEvents().eventCommunityInBound
    --if eventInBound and eventInBound:HasNotification() then
    --    self.config.notiWiki2.gameObject:SetActive(eventInBound:HasNotification())
    --end
end

--- @return void
function UIMainAreaView:CheckNotificationDailyGift()
    --- @type PlayerDailyDataInBound
    local dailyRewardData = zg.playerData:GetMethod(PlayerDataMethod.DAILY_REWARD)
    if dailyRewardData ~= nil then
        self.config.notiDaily:SetActive(dailyRewardData:CanClaim())
    end
end

function UIMainAreaView:CheckNotificationVideoRewarded()
    --- @type VideoRewardedInBound
    local videoData = zg.playerData:GetMethod(PlayerDataMethod.REWARD_VIDEO)
    local enable = VideoRewardedUtils.IsAvailable() and videoData:CanWatch()
    self.config.videoRewarded.gameObject:SetActive(true)
    self.config.notiVideoRewarded:SetActive(enable)
end

function UIMainAreaView:CheckNotificationHandOfMidas(data)
    ---@type HandOfMidasInBound
    local server = zg.playerData:GetMethod(PlayerDataMethod.HAND_OF_MIDAS)
    if server == nil then
        XDebug.Error("hand of midas data can't be nil")
    elseif (data == nil or data == 1) then
        if data == nil then
            server:SetTimeRefresh()
        end
        self.config.notiHandOfMidas:SetActive(server:CanClaim(1))
    end
end

function UIMainAreaView:CheckNotificationDefenseMode()
    self.mainAreaWorld:EnableFeatureNotify(FeatureType.DEFENSE, false)
    local result = function(isNotified)
        self.mainAreaWorld:EnableFeatureNotify(FeatureType.DEFENSE, isNotified)
    end
    NotificationCheckUtils.DefenseModeNotificationCheck(result)
end

function UIMainAreaView:CheckNotificationHeroLinking()
    self.config.notiHeroCollection:SetActive(NotificationCheckUtils.CheckNotiHeroLinking() or NotificationCheckUtils.CheckNotiTalent() or NotificationCheckUtils.CheckNotiRecycle())
end

function UIMainAreaView:CheckSoftTutHero()
    local isActive = NotificationCheckUtils.IsCanShowSoftTutRegression()
            and NotificationFragment.IsCanShowSoftTutFragment() == false
            and (NotificationCheckUtils.IsCanShowSoftTutCampaign() == false)
            and (NotificationCheckUtils.IsCanShowSoftTutTower() == false)
    self.config.softTutHero:SetActive(isActive)
end

function UIMainAreaView:OnNotifiedQuestRequest()
    self:CheckNotificationQuest()
    if zg.netDispatcherMgr:ExistEvent(OpCode.QUEST_DATA_GET) == false then
        self:CheckOpenMiniQuestTree()
    end
end

function UIMainAreaView:CheckNotificationEventPopup()
    EventInBound.ValidateEventModel(function()
        --- @type EventInBound
        local eventInBound = zg.playerData:GetEvents()
        local hasNotification = eventInBound:HasNotificationEventPopup()
        self.mainAreaWorld:EnableMissionNotification(hasNotification)

        self:CheckNotificationIapShop()
        self:CheckNotificationSummon()
        self:CheckNotificationDungeon()
        self:CheckNotificationGuild()
        self:CheckNotificationArena()
        self:CheckEnableSaleOff()
        self:CheckEnableEventMidAutumn()
        self:CheckEnableEventHalloween()
        self:CheckEnableEventXmas()
        self:CheckEnableEventNewYear()
        self:CheckEnableEventBlackFriday()
        self:CheckEnableLunarEventNewYear()
        self:CheckEnableLunarPath()
        self:CheckEnableEventValentine()
        --self:CheckEnableEventNewHeroSummon()
        self:CheckEnableEventNewHero()
        self:CheckEnableEventMergeServer()
        self:CheckEnableEventEasterEgg()
        self:CheckEnableEventBirthday()
        self:CheckEnableEventSkinBundle()
        self:CheckEnableEventHeroRelease()
        self:CheckEnableEventBattlePass()
        self:CheckEnableEventNewServerWeek()
        self:CheckEnableEventNewServerWeek2()
        self:CheckEnableEventNewServerWeek3()
        self:CheckEnableEventIdleEffect()
        self:CheckEnableEventKazetsu()
        self:CheckEnableEventKazetsuSummon()
        self:CheckEnableEventFindeBoss()
        self:CheckEnableEventPuzzle()
        self:CheckEnableEventZodiac()
        self:CheckEnableEventNewVip()
        self:CheckEnableEventSkinChallenge()
        self:CheckEnableEventAiryuu()
        self:CheckEnableEventTowerOfEitri()
        self:CheckEnableEventSeasonal()
        self:CheckEnableEventBossChallenge()
        self:CheckEnableEventPieceAdventure()
        self:CheckEnableEventRateUpSummon()
        self:CheckEnableEventBlackFridayNewVersion()
        self:CheckEnableEventThanksGiving()
        self:CheckEnableEventChristmas()
        self:CheckEnableEventNewYear2023()
        self:CheckEnableEventLunarNewYear2024()
        self:CheckEnableEventValentine2024()
        self:CheckEnableEventDailyQuestPass()
        self:CheckEnableEventEasterDay()
        self:CheckEnableEventSummerDay()
        self:CheckEnableEventBlossomDay()
        self:CheckEnableEventQixiFestival()
        self:CheckEnableEventMayDay()
    end, nil, false, false)
end

function UIMainAreaView:CheckNotificationQuest()
    --- @type QuestDataInBound
    local questDataInBound = zg.playerData:GetQuest()
    if questDataInBound ~= nil then
        self.config.notiQuest:SetActive(questDataInBound.hasNotification)
    end
end

--- @return void
function UIMainAreaView:CheckNotificationTavern()
    local notify = false
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.TAVERN, false) == true then
        --- @type PlayerTavernDataInBound
        local data = zg.playerData:GetMethod(PlayerDataMethod.TAVERN)
        if data ~= nil then
            notify = data:IsContainQuestWaiting()
        end
    end
    self.mainAreaWorld:EnableFeatureNotify(FeatureType.TAVERN, notify)
end

--- @return void
function UIMainAreaView:CheckNotificationRaid()
    local notify = false
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.RAID, false) == true then
        notify = InventoryUtils.GetMoney(MoneyType.RAID_GOLD_TURN) > 0
                or InventoryUtils.GetMoney(MoneyType.RAID_MAGIC_POTION_TURN) > 0
                or InventoryUtils.GetMoney(MoneyType.RAID_HERO_FRAGMENT_TURN) > 0
    end
    self.mainAreaWorld:EnableFeatureNotify(FeatureType.RAID, notify)
end

--- @return void
function UIMainAreaView:CheckNotificationFragment(data)
    if data == nil
            or data.resourceType == ResourceType.HeroFragment
            or data.resourceType == ResourceType.ItemFragment then
        NotificationFragment.CheckNotificationFragment(self.config.notiInventory)
    end
end

--- @return void
function UIMainAreaView:CheckNotificationInventory()
    local checkNoti = function()
        NotificationCheckUtils.BoxNotificationCheck(self.config.notiInventory)
        if self.config.notiInventory.activeSelf == false then
            self:CheckNotificationFragment()
        end
    end
    local checkNotiSoftTutFragment = function()
        local isActive = NotificationFragment.IsCanShowSoftTutFragment()
                and (NotificationCheckUtils.IsCanShowSoftTutCampaign() == false)
                and (NotificationCheckUtils.IsCanShowSoftTutTower() == false)
        self.config.softTutInventory:SetActive(isActive)
    end
    checkNoti()
    checkNotiSoftTutFragment()
    if self.subscriptionNotiInventory == nil then
        self.subscriptionNotiInventory = RxMgr.changeResource:Subscribe(function(data)
            if (data.resourceType == ResourceType.Money and data.resourceId == MoneyType.EVENT_CHRISTMAS_BOX)
                    or (data.resourceType == ResourceType.HeroFragment) or (data.resourceType == ResourceType.ItemFragment) then
                checkNoti()
            end
            if (data.resourceType == ResourceType.HeroFragment) then
                checkNotiSoftTutFragment()
            end
        end)
    end
end

--- @return void
function UIMainAreaView:CheckNotificationModeShop()
    local methodList = { PlayerDataMethod.MARKET, PlayerDataMethod.ARENA_MARKET, PlayerDataMethod.ARENA_TEAM_MARKET }
    local isNotify = false
    --XDebug.Log("Check Mode Shop Count: " .. #methodList)
    for _, v in ipairs(methodList) do
        --XDebug.Log("Check Mode Shop: " .. tostring(v))
        local notify = NotificationCheckUtils.ShopCheckNotification(v)
        if notify then
            isNotify = notify
        end
    end
    self.mainAreaWorld:EnableFeatureNotify(FeatureType.BLACK_MARKET, isNotify)
end

--- @return void
function UIMainAreaView:CheckNotificationCampaign()
    --self:CheckNotificationCampaignTraining()
end

--- @return void
function UIMainAreaView:CheckNotificationCampaignTraining()
    ---@type CampaignData
    local campaignData = zg.playerData:GetCampaignData()
    if campaignData:ValidateStageIdle() then
        local timeNoti = campaignData:GetTimeToMaxIdle()
        if ClientConfigUtils.CheckUnlockMinorFeatureAndNotification(MinorFeatureType.CAMPAIGN_AUTO_TRAIN, false) then
            timeNoti = math.min(timeNoti, campaignData:GetTimeFinishTraining())
        end
        if timeNoti > 0 then
            self.mainAreaWorld:EnableFeatureNotify(FeatureType.CAMPAIGN, false)
            self.coroutineNotiCampaign = Coroutine.start(function()
                coroutine.waitforseconds(timeNoti)
                self.mainAreaWorld:EnableFeatureNotify(FeatureType.CAMPAIGN, true)
            end)
        else
            self.mainAreaWorld:EnableFeatureNotify(FeatureType.CAMPAIGN, true)
        end
    else
        self.mainAreaWorld:EnableFeatureNotify(FeatureType.CAMPAIGN, false)
    end
end

--- @return void
function UIMainAreaView:RemoveCheckNotificationCampaign()
    if self.coroutineNotiCampaign ~= nil then
        Coroutine.stop(self.coroutineNotiCampaign)
        self.coroutineNotiCampaign = nil
    end
end

--- @return void
function UIMainAreaView:CheckNotificationSummon()
    self.mainAreaWorld:EnableFeatureNotify(FeatureType.SUMMON, false)
    --- @type HeroSummonInBound
    local server = zg.playerData:GetMethod(PlayerDataMethod.SUMMON)
    local isAvailableFreeBasic = server:IsAvailableFreeSummon(SummonType.Basic)
    local isAvailableFreeHeroic = server:IsAvailableFreeSummon(SummonType.Heroic)

    if isAvailableFreeBasic or isAvailableFreeHeroic then
        self.mainAreaWorld:EnableFeatureNotify(FeatureType.SUMMON, true)
        return
    else
        local eventSummon = { EventTimeType.EVENT_RATE_UP, EventTimeType.EVENT_HERO_RELEASE }
        for i = 1, #eventSummon do
            local eventPopupModel = zg.playerData:GetEvents():GetEvent(eventSummon[i])
            if eventPopupModel ~= nil and eventPopupModel:IsOpening() and eventPopupModel:IsNotifySummon() then
                self.mainAreaWorld:EnableFeatureNotify(FeatureType.SUMMON, true)
                break
            end
        end
    end
end

--- @return void
function UIMainAreaView:CheckNotificationArena()
    require("lua.client.scene.ui.notification.NotificationArena")
    require("lua.client.scene.ui.notification.NotificationArenaTeam")
    self.mainAreaWorld:EnableFeatureNotify(FeatureType.ARENA, NotificationArena.IsNotification() or NotificationArenaTeam.IsNotification())
end

--- @return void
function UIMainAreaView:CheckEnableSaleOff()
    self.config.tagSale:SetActive(false)
    local eventInBound = zg.playerData:GetEvents()
    if eventInBound ~= nil then
        --- @type EventSaleOffModel
        local eventSaleOffModel = eventInBound:GetEvent(EventTimeType.EVENT_SALE_OFF)
        if eventSaleOffModel ~= nil then
            local isOpening = eventSaleOffModel:IsOpening()
            self.config.tagSale:SetActive(isOpening)
            if isOpening then
                local onUpdate = function(timeRefresh)
                    self.config.textSaleOffTimer.text = TimeUtils.GetDeltaTime(timeRefresh)
                    if timeRefresh < 0 then
                        self.config.tagSale:SetActive(false)
                    end
                end
                eventSaleOffModel:StartRefreshTime(onUpdate)
            end
        end
    end
end

function UIMainAreaView:CheckEnableEventMidAutumn()
    --- @type EventMidAutumnModel
    local eventMidAutumnModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MID_AUTUMN)
    local isOpening = eventMidAutumnModel ~= nil and eventMidAutumnModel.timeData:IsOpening()
    self.config.buttonMidAutumn.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notifyMidAutumn:SetActive(eventMidAutumnModel:HasNotification())
    end
end
function UIMainAreaView:CheckEnableEventHalloween()
    ----- @type EventHalloweenModel
    local eventHalloweenModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HALLOWEEN)
    local isOpening = eventHalloweenModel ~= nil and eventHalloweenModel.timeData:IsOpening()
    self.config.buttonHalloween.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notifyHalloween:SetActive(eventHalloweenModel:HasNotification())
    end
end

function UIMainAreaView:CheckEnableEventXmas()
    ----- @type EventXmasModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    self.config.buttonXmas.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notifyXmas:SetActive(eventModel:HasNotification())
    end
end

function UIMainAreaView:CheckEnableEventNewYear()
    ----- @type EventNewYearModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    --local isValid = eventModel ~= nil --  and eventModel:IsValidCardDuration()
    self.config.buttonNewYear.gameObject:SetActive(isOpening) --  or isValid
    if isOpening then
        self.config.notifyNewYear:SetActive(eventModel:HasNotification())
    end
end

function UIMainAreaView:CheckEnableLunarEventNewYear()
    ----- @type EventLunarNewYearModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2022)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    self.config.buttonLunarNewYear.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notifyLunarNewYear.gameObject:SetActive(eventModel:HasNotification())
    end
end

function UIMainAreaView:CheckEnableLunarPath()
    --- @type EventLunarPathModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_PATH)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    self.config.buttonLunarPath.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notifyLunarPath.gameObject:SetActive(eventModel:HasNotification())
    end
end

function UIMainAreaView:CheckEnableEventValentine()
    --- @type EventValentineModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_VALENTINE)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    self.config.buttonValentine.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notifyValentine.gameObject:SetActive(eventModel:HasNotification())
    end
end

function UIMainAreaView:CheckEnableEventNewHeroSummon()
    --- @type EventNewHeroSummonModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_SUMMON)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    self.config.buttonEventNewHeroSummon.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notifyEventNewHeroSummon.gameObject:SetActive(eventModel:HasNotification())
        self.config.iconNewHeroSummon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas("IconEventNewHeroSummon", eventModel.timeData.dataId)
        self.config.iconNewHeroSummon:SetNativeSize()
    end
end

function UIMainAreaView:CheckEnableEventNewHero()
    local eventInBound = zg.playerData:GetEvents()
    local isOpeningEventNewHero = eventInBound:IsOpeningEventNewHero()
    self.config.buttonEventNewHero.gameObject:SetActive(isOpeningEventNewHero)
    if isOpeningEventNewHero then
        self.config.notifyNewHero.gameObject:SetActive(eventInBound:HasNotificationEventNewHero())
        --- @type EventNewHeroSummonModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_SUMMON)
        if eventModel ~= nil and eventModel:IsOpening() then
            self.config.iconEventNewHero.sprite = ResourceLoadUtils.LoadTexture("IconEventNewHero", eventModel.timeData.dataId, ComponentName.UnityEngine_Sprite)
            self.config.iconEventNewHero:SetNativeSize()
        else
            eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_BOSS_LEADER_BOARD)
            local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
            if isOpening then
                self.config.buttonEventNewHero.gameObject:SetActive(isOpening)
                self.config.notifyNewHero.gameObject:SetActive(eventModel:HasNotification())

                self.config.iconEventNewHero.sprite = ResourceLoadUtils.LoadTexture("IconEventNewHeroSummon", eventModel.timeData.dataId, ComponentName.UnityEngine_Sprite)
                self.config.iconEventNewHero:SetNativeSize()
            end
        end
    end
end

function UIMainAreaView:CheckEnableEventBlackFriday()
    --- @type EventBlackFridayModel
    local eventBlackFridayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY)
    local isOpening = eventBlackFridayModel ~= nil and eventBlackFridayModel.timeData:IsOpening()
    self.config.buttonBlackFriday.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notifyBlackFriday:SetActive(eventBlackFridayModel:HasNotification())
    end
end

function UIMainAreaView:CheckEnableEventMergeServer()
    --- @type EventMergeServerModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MERGE_SERVER)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    self.config.buttonEventMergeServer.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notifyMergeServer.gameObject:SetActive(eventModel:HasNotification())
    end
end

function UIMainAreaView:CheckEnableEventEasterEgg()
    --- @type EventEasterEggModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    self.config.buttonEventEasterEgg.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notifyEventEasterEgg.gameObject:SetActive(eventModel:HasNotification())
    end
end

function UIMainAreaView:CheckEnableEventBirthday()
    --- @type EventBirthdayModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    self.config.buttonBirthday.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notifyBirthday.gameObject:SetActive(eventModel:HasNotification())
    end
end

function UIMainAreaView:CheckEnableEventSkinBundle()
    --- @type EventSkinBundleModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_BUNDLE)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    self.config.buttonSkinBundle.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notifySkinBundle.gameObject:SetActive(eventModel:HasNotification())
    end
end

function UIMainAreaView:CheckEnableEventHeroRelease()
    --- @type EventHeroReleaseModel
    local eventHeroReleaseModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HERO_RELEASE)
    local isOpening = eventHeroReleaseModel ~= nil and eventHeroReleaseModel:IsOpening()
    self.config.buttonEventHeroRelease.gameObject:SetActive(isOpening)
    self.config.buttonEventHeroReleaseSummon.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notifyEventHeroRelease.gameObject:SetActive(eventHeroReleaseModel:HasNotification())
        ---@type number
        local dataId = eventHeroReleaseModel.timeData.dataId
        self.config.iconEventHeroRelease.sprite = eventHeroReleaseModel:GetEventIcon()
        self.config.iconEventHeroRelease:SetNativeSize()
        self.config.textEventHeroRelease.text = LanguageUtils.LocalizeCommon("event_hero_release_" .. dataId)
        self.config.iconEventHeroReleaseSummon.sprite = ResourceLoadUtils.LoadTexture("IconEventHeroReleaseSummon", tonumber(dataId), ComponentName.UnityEngine_Sprite)
        self.config.iconEventHeroReleaseSummon:SetNativeSize()
        self.config.textEventHeroReleaseSummon.text = LanguageUtils.LocalizeCommon("event_hero_release_summon_" .. dataId)
    end
end

function UIMainAreaView:CheckEnableEventWelcomeBack()
    WelcomeBackInBound.Validate(function()
        --- @type WelcomeBackInBound
        local welcomeBackInBound = zg.playerData:GetMethod(PlayerDataMethod.COMEBACK)
        if welcomeBackInBound == nil then
            self.config.buttonWelcomeBack.gameObject:SetActive(false)
            return
        end
        self.config.buttonWelcomeBack.gameObject:SetActive(welcomeBackInBound.isInComingBackEvent)
        if welcomeBackInBound.isInComingBackEvent then
            self.config.notifyWelcomeBack.gameObject:SetActive(welcomeBackInBound:HasNotification())
        end
    end)
end

--- @return void
function UIMainAreaView:RemoveCheckNotificationSummon()
    if self.coroutineNotiSummon ~= nil then
        Coroutine.stop(self.coroutineNotiSummon)
        self.coroutineNotiSummon = nil
    end
end

--- @return void
function UIMainAreaView:RemoveCheckNotificationEventServerOpen()
    if self.subscriptionQuestServerOpenComplete ~= nil then
        self.subscriptionQuestServerOpenComplete:Unsubscribe()
        self.subscriptionQuestServerOpenComplete = nil
    end
end

function UIMainAreaView:CheckNotificationDungeon()
    self.mainAreaWorld:EnableFeatureNotify(FeatureType.DUNGEON, false)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.DUNGEON, false) then
        local getDungeonCheckInOpen = Job(function(onSuccess, onFailed)
            --- @type EventInBound
            local eventInBound = zg.playerData:GetEvents()
            --- @return EventPopupModel
            local dungeonTime = eventInBound:GetEvent(EventTimeType.DUNGEON)
            --- @type DungeonInBound
            local dungeonInBound = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON)
            if dungeonInBound ~= nil and dungeonTime.timeData.season ~= dungeonInBound.dungeonCheckInOpenSeason then
                DungeonInBound.GetDungeonCheckInOpen(onSuccess, onFailed)
            else
                onSuccess()
            end
        end)

        local checkNotify = function()
            --- @type DungeonInBound
            local dungeonInBound = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON)
            ---@type EventPopupModel
            local eventPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.DUNGEON)
            if eventPopupModel:IsOpening() == true then
                if dungeonInBound.bindingHeroList:Count() == 0
                        and dungeonInBound.dungeonCheckInOpenSeason ~= eventPopupModel.timeData.season then
                    self.mainAreaWorld:EnableFeatureNotify(FeatureType.DUNGEON, true)
                end
            end
        end
        --- @type Job
        local jobMultiple = getDungeonCheckInOpen
        jobMultiple:Complete(checkNotify)
    end
end

--- @return void
function UIMainAreaView:RemoveCheckNotificationDungeon()
    if self.coroutineNotiSummon ~= nil then
        Coroutine.stop(self.coroutineNotiSummon)
        self.coroutineNotiSummon = nil
    end
end

--- @return void
function UIMainAreaView:CheckRename()
    ---@type string
    local name = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).name
    self.config.textName.text = name:len() <= 15 and name or name:sub(15, -1) .. "..."
end

function UIMainAreaView:OnClickFlashSaleNew()
    PopupMgr.ShowPopup(UIPopupName.UIFlashSaleNew)
end

function UIMainAreaView:_InitButtonListener()
    self.config.bundleDropdownButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBundleDropDown()
    end)
    self.config.cashShop.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCashShop()
    end)
    self.config.btnFlashSaleNew.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickFlashSaleNew()
    end)
    self.config.btnFlashSale.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickFlashSale()
    end)
    self.config.dailyCheckin.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "daily_checkin")
        UIBaseView.CheckBlurMain(true, true, function()
            PopupMgr.ShowPopup(UIPopupName.UIDailyReward)
        end)
    end)
    self.config.iconSetting.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSetting()
    end)
    self.config.buttonVip.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickVip()
    end)
    self.config.heroList.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        FeatureMapping.GoToFeature(FeatureType.HERO_LIST, true)
    end)
    self.config.handOfMidas.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        FeatureMapping.GoToFeature(FeatureType.HAND_OF_MIDAS, true)
    end)
    self.config.inventory.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        FeatureMapping.GoToFeature(FeatureType.INVENTORY, true)
    end)
    self.config.mastery.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        FeatureMapping.GoToFeature(FeatureType.MASTERY, true)
    end)
    self.config.summoner.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        FeatureMapping.GoToFeature(FeatureType.SUMMONER, true)
    end)
    self.config.raiseLevel.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        FeatureMapping.GoToFeature(FeatureType.RAISE_LEVEL, true)
    end)
    self.config.quest.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:_OnClickShowQuest()
    end)
    self.config.buttonMidAutumn.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventMidAutumn()
    end)
    self.config.buttonHalloween.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHalloween()
    end)
    self.config.buttonXmas.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickXmas()
    end)
    self.config.buttonNewYear.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickNewYear()
    end)
    self.config.buttonLunarNewYear.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLunarNewYear()
    end)
    self.config.buttonBlackFriday.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBlackFriday()
    end)
    self.config.trialMonthlyCard.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickTrialMonthlyCard()
    end)

    self.config.firstPurchase.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickFirstPurchase(function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIFirstPurchase)
        end)
    end)
    self.config.buttonStarterPack.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickStarterPack(function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIStarterPackNew)
        end)
    end)
    self.config.videoRewarded.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        local data = {}
        data.callbackClose = function()
            self:CheckNotificationVideoRewarded()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIFreeGemPopup)
        end
        PopupMgr.ShowPopup(UIPopupName.UIFreeGemPopup, data)
    end)
    self.config.mail.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        FeatureMapping.GoToFeature(FeatureType.MAIL, true)
    end)

    self.config.wiki.gameObject:SetActive(false)
    self.config.wiki.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        UIBaseView.CheckBlurMain(true, true, function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIWiki, nil, UIPopupName.UIMainArea)
        end)
    end)
    --self.config.wiki2.gameObject:SetActive(false)
    self.config.wiki2.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        UIBaseView.CheckBlurMain(true, true, function()
            PopupMgr.ShowPopup(UIPopupName.UICommunityTotal)
        end)
    end)
    self.config.friend.gameObject:SetActive(false)
    self.config.friend.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        FeatureMapping.GoToFeature(FeatureType.FRIENDS, true)
    end)
    self.config.iconChat.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChat()
    end)
    self.config.iconCheat.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIPopupFakeData)
    end)
    self.config.firstTimeReward.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickFirstTimeReward()
    end)
    self.config.eventServerOpen.transform:SetAsLastSibling()
    self.config.eventServerOpen.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventServerOpen()
    end)
    self.config.buttonLunarPath.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLunarPath()
    end)
    self.config.buttonValentine.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickValentine()
    end)
    self.config.buttonEventNewHeroSummon.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        FeatureMapping.GoToFeature(FeatureType.SUMMON, true)
    end)
    if self.config.buttonSpecialOffer then
        self.config.buttonSpecialOffer.onClick:AddListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            self:OnClickSpecialOffer(function()
                PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UISpecialOfferShop)
            end)
        end)
    end
    if self.config.buttonLeft ~= nil then
        self.config.buttonLeft.onClick:AddListener(function()
            self.mainAreaWorld:ClampScrollPosition(U_Vector3.right * 1000000)
        end)
    end
    if self.config.buttonRight ~= nil then
        self.config.buttonRight.onClick:AddListener(function()
            self.mainAreaWorld:ClampScrollPosition(U_Vector3.left * 1000000)
        end)
    end
    self.config.buttonEventNewHero.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventNewHero()
    end)
    self.config.buttonEventMergeServer.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventMergeServer()
    end)
    self.config.buttonEventEasterEgg.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventEasterEgg()
    end)
    self.config.buttonWelcomeBack.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickWelcomeBack()
    end)
    self.config.buttonBirthday.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBirthday()
    end)
    self.config.buttonSkinBundle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventSkinBundle()
    end)
    self.config.buttonEventHeroRelease.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventHeroRelease()
    end)
    self.config.buttonEventHeroReleaseSummon.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventHeroReleaseSummon()
    end)
    self.config.battlePass.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBattlePass()
    end)
    self.config.newServerWeek.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickNewServerWeek()
    end)
    self.config.newServerWeekCheckin.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickNewServerWeekCheckIn()
    end)
    self.config.newServerWeek2.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickNewServerWeek2()
    end)
    self.config.newServerWeek3.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickNewServerWeek3()
    end)

    self.config.idleEffectBundle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickIdleEffectBundle()
    end)

    self.config.eventKazetsu.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventKazetsu()
    end)

    self.config.buttonEventKazetsuSummon.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventKazetsuSummon()
    end)

    self.config.buttonEventNewHeroRateupSummon.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventNewHeroRateUpSummon()
    end)

    self.config.buttonEventFindeBoss.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventFindeBoss()
    end)

    self.config.buttonEventPuzzle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventPuzzle()
    end)

    self.config.buttonEventZodiac.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventZodiac()
    end)

    self.config.buttonEventSkinChallenge.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventSkinChallenge()
    end)

    self.config.buttonEventNewVip.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventNewVip()
    end)

    self.config.buttonEventAiryuu.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventAiryuu()
    end)
    self.config.buttonEventTowerOfEitri.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventTowerOfEitri()
    end)
    self.config.buttonEventSeasonal.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventSeasonal()
    end)
    self.config.buttonBoostFirstPurchase.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBoostFirstPurchase()
    end)
    self.config.buttonFlashSaleEvolve.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickFlashSaleEvolve()
    end)
    self.config.buttonEventBossChallenge.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventBossChallenge()
    end)
    self.config.buttonEventPieceAdventure.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventPieceAdventure()
    end)
    self.config.buttonEventBlackFridayNewVersion.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventBlackFridayNewVersion()
    end)
    self.config.buttonEventThanksGiving.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventThanksGiving()
    end)
    self.config.buttonEventChristmas.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventChristmas()
    end)
    self.config.buttonEventNewYear2023.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventNewYear2023()
    end)
    self.config.buttonEventLunarNewYear2024.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventLunarNewYear2024()
    end)
    self.config.buttonEventValentine2024.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventValentine2024()
    end)
    self.config.buttonEventDailyQuestPass.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventDailyQuestPass()
    end)
    self.config.buttonEventEasterDay.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventEasterDay()
    end)
    self.config.buttonEventSummerDay.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventSummerDay()
    end)
    self.config.buttonEventBlossomDay.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventBlossomDay()
    end)
    self.config.buttonEventQixiFestival.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventQixiFestival()
    end)
    self.config.buttonEventMayDay.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEventMayDay()
    end)
end

function UIMainAreaView:SetStateBundleDropDown()
    local activeNumber = self:CountActiveBundleItem()
    self.config.bundleDropdownContainer:SetActive(false)
    if activeNumber > 0 then
        self.config.bundleDropdownContainer:SetActive(true)
        self:SetStateBundleDropDownBg(activeNumber)
        self:SetStateBundleDropDownArrow()
        self:SetTextBundleNumberCount()
        if not self.isShowBundle then
            self:SetTextBundleNumberCount(activeNumber)
        end
        local pos = self.config.bundleDropdownPopupImg.transform.localPosition
        pos.y = 0
        self.config.bundleDropdownPopupImg.transform.localPosition = pos
    end
end

function UIMainAreaView:OnClickBundleDropDown()
    self.isShowBundle = not self.isShowBundle
    self:SetStateBundleDropDown()
    self:DropDownAnim()
end

function UIMainAreaView:SetStateBundleDropDownBg(activeNumber)
    if activeNumber > 5 then
        self.config.bundleDropdownPopupImg.enabled = false
        self.config.bundleScrollBorder:SetActive(true)
        self.config.bundleScroll.vertical = true
    else
        self.config.bundleDropdownPopupImg.enabled = true
        self.config.bundleScrollBorder:SetActive(false)
        self.config.bundleScroll.vertical = false
    end
end

function UIMainAreaView:SetStateBundleDropDownArrow()
    --- @type UnityEngine_Vector3
    local scale = self.config.bundleDropdownArrow.transform.localScale
    scale.y = scale.y * -1
    self.config.bundleDropdownArrow.transform.localScale = scale
end

function UIMainAreaView:DropDownAnim()
    --- @type UnityEngine_Vector3
    local localPosition = self.config.bundleDropdownPopupImg.gameObject.transform.localPosition
    local heightPerChild = 150
    local height = heightPerChild * self:CountActiveBundleItem()
    local moveStep = height * 0.1
    self.config.bundleScrollContainer:SetActive(true)
    self.coroutine = Coroutine.start(function()
        if self.isShowBundle then
            self.config.bundleScrollContainer:SetActive(true)
            localPosition.y = height
            while localPosition.y > 0 do
                localPosition.y = localPosition.y - moveStep
                if localPosition.y < 0 then
                    localPosition.y = 0
                end
                self.config.bundleDropdownPopupImg.gameObject.transform.localPosition = localPosition
                coroutine.waitforendofframe()
            end
        else
            localPosition.y = 0
            while localPosition.y < height do
                localPosition.y = localPosition.y + moveStep
                if localPosition.y > height then
                    localPosition.y = height
                end
                self.config.bundleDropdownPopupImg.gameObject.transform.localPosition = localPosition
                coroutine.waitforendofframe()
            end
            self.config.bundleScrollContainer:SetActive(false)
        end
    end)
end

--- @return void
function UIMainAreaView:SetTextBundleNumberCount(activeNumber)
    self.config.bundleDropdownNotiNumber.text = activeNumber
    self.config.bundleDropdownNoti:SetActive(true)
    if not activeNumber or activeNumber <= 0 then
        self.config.bundleDropdownNoti:SetActive(false)
    end
end

--- @return number
function UIMainAreaView:CountActiveBundleItem()
    local activeNumber = 0
    local childCount = self.config.bundleDropdownPopupImg.transform.childCount
    for i = 0, childCount - 1 do
        if self.config.bundleDropdownPopupImg.transform:GetChild(i).gameObject.activeSelf == true then
            activeNumber = activeNumber + 1
        end
    end
    return activeNumber
end

function UIMainAreaView:OnClickChat()
    local show = function()
        PopupMgr.ShowPopup(UIPopupName.UIChat, ChatLayoutType.MAIN_MENU)
    end
    ChatData.OnValidateMainMenuChat(show)
end

function UIMainAreaView:OnClickCashShop()
    TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "iap_shop")
    PopupMgr.ShowAndHidePopup(UIPopupName.UIIapShop, nil, UIPopupName.UIMainArea)
end

function UIMainAreaView:OnClickEventMidAutumn()
    local openEvent = function()
        --- @type EventMidAutumnModel
        local eventMidAutumnModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MID_AUTUMN)
        if eventMidAutumnModel:IsOpening() then
            PopupMgr.ShowAndHidePopup(UIPopupName.UIEventMidAutumn, nil, UIPopupName.UIMainArea)
        else
            self.config.buttonMidAutumn.gameObject:SetActive(false)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        end
    end
    EventInBound.ValidateEventModel(openEvent)
end

function UIMainAreaView:OnClickHalloween()
    local openEvent = function()
        --- @type EventHalloweenModel
        local eventMidAutumnModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HALLOWEEN)
        if eventMidAutumnModel:IsOpening() then
            PopupMgr.ShowAndHidePopup(UIPopupName.UIEventHalloween, nil, UIPopupName.UIMainArea)
        else
            self.config.buttonHalloween.gameObject:SetActive(false)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        end
    end
    EventInBound.ValidateEventModel(openEvent)
end

function UIMainAreaView:OnClickXmas()
    local openEvent = function()
        --- @type EventXmasModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
        if eventModel:IsOpening() then
            PopupMgr.ShowAndHidePopup(UIPopupName.UIEventXmas, nil, UIPopupName.UIMainArea)
        else
            self.config.buttonXmas.gameObject:SetActive(false)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        end
    end
    EventInBound.ValidateEventModel(openEvent)
end

function UIMainAreaView:OnClickNewYear()
    local openEvent = function()
        --- @type EventNewYearModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR)
        if eventModel ~= nil and eventModel:IsOpening() then
            PopupMgr.ShowAndHidePopup(UIPopupName.UIEventNewYear, nil, UIPopupName.UIMainArea)
        else
            local isValid = eventModel:IsValidCardDuration()
            self.config.buttonNewYear.gameObject:SetActive(isValid)
            if isValid then
                PopupMgr.ShowAndHidePopup(UIPopupName.UIEventNewYear, nil, UIPopupName.UIMainArea)
            else
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            end
        end
    end
    EventInBound.ValidateEventModel(openEvent)
end

function UIMainAreaView:OnClickLunarNewYear()
    EventInBound.ValidateEventModel(function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventLunarNewYear, nil, UIPopupName.UIMainArea)
    end)
end

function UIMainAreaView:OnClickBlackFriday()
    local openEvent = function()
        --- @type EventHalloweenModel
        local eventBlackFriday = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY)
        if eventBlackFriday:IsOpening() then
            UIBaseView.CheckBlurMain(true, true, function()
                PopupMgr.ShowPopup(UIPopupName.UIEventBlackFriday)
            end)
        else
            self.config.buttonBlackFriday.gameObject:SetActive(false)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        end
    end
    EventInBound.ValidateEventModel(openEvent)
end

function UIMainAreaView:OnClickMission()
    local validateEventModel = Job(function(onSuccess, _)
        EventInBound.ValidateEventModel(onSuccess)
    end)
    local validateEventCommunity = Job(function(onSuccess, _)
        EventCommunityInBound.ValidateData(onSuccess)
    end)
    local doneValidate = function()
        UIBaseView.CheckBlurMain(true, true, function()
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "event")
            PopupMgr.ShowAndHidePopup(UIPopupName.UIEvent, nil, UIPopupName.UIMainArea)
        end)
    end
    --- @type Job
    local jobMultiple = validateEventModel + validateEventCommunity
    jobMultiple:Complete(doneValidate)
end

function UIMainAreaView:OnClickFirstPurchase(callbackClose)
    local eventHasEnded = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        self.config.firstPurchase.gameObject:SetActive(false)
    end
    --- @type ProgressPackCollection
    local progressPackCollection = zg.playerData:GetMethod(PlayerDataMethod.IAP).progressPackData
    local listGroupProductConfig = progressPackCollection:GetListActiveGroupByViewType(PackViewType.FIRST_TIME_PACK)
    if listGroupProductConfig:Count() > 0 then
        --- @type GroupProductConfig
        local groupProductConfig = listGroupProductConfig:Get(1)
        local groupId = groupProductConfig.groupId
        local groupCreatedTime = progressPackCollection.activeProgressPackDict:Get(groupId)
        if (groupProductConfig.duration - (zg.timeMgr:GetServerTime() - groupCreatedTime)) > 0 then
            --[[            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.FIRST_PURCHASE, "true")
                        UIBaseView.CheckBlurMain(true, true, function()
                            PopupMgr.ShowPopup(UIPopupName.UIFirstPurchase, { ["callbackClose"] = callbackClose })
                        end)]]
        else
            eventHasEnded()
        end
    else
        eventHasEnded()
    end
end

function UIMainAreaView:OnClickFirstPurchaseFake(id, callbackClose)
    require "lua.client.core.network.fake.FakeDataRequest"
    local touchObject = TouchUtils.Spawn("UIMainAreaView:OnClickFirstPurchaseFake")
    FakeDataRequest.FakeFirstTimePurchase(id, function()
        self:OnClickFirstPurchase(callbackClose)
        touchObject:Enable()
    end)
end

function UIMainAreaView:OnClickFlashSale(callbackClose)
    local eventHasEnded = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        self.config.btnFlashSale.gameObject:SetActive(false)
    end
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    --- @type ProgressPackCollection
    local progressPackCollection = iapDataInBound.progressPackData
    local listGroupProductConfig = progressPackCollection:GetListActiveGroupByViewType(PackViewType.FLASH_SALE_PACK)
    if listGroupProductConfig:Count() > 0 then
        --- @type GroupProductConfig
        local groupProductConfig = listGroupProductConfig:Get(1)
        local groupId = groupProductConfig.groupId
        local groupCreatedTime = progressPackCollection.activeProgressPackDict:Get(groupId)
        if (groupProductConfig.duration - (zg.timeMgr:GetServerTime() - groupCreatedTime)) > 0 then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.FLASH_SALE, "true")
            UIBaseView.CheckBlurMain(true, true, function()
                --PopupMgr.ShowPopup(UIPopupName.UIHiddenDeal, { ["callbackClose"] = callbackClose })
                PopupMgr.ShowPopup(UIPopupName.UIFlashSale, { ["callbackClose"] = callbackClose })
            end)
        else
            eventHasEnded()
        end
    else
        eventHasEnded()
    end
end

function UIMainAreaView:OnClickSpecialOffer(callbackClose)
    local eventHasEnded = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        self.config.buttonSpecialOffer.gameObject:SetActive(false)
    end
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    --- @type ProgressPackCollection
    local progressPackCollection = iapDataInBound.progressPackData
    local listGroupProductConfig = progressPackCollection:GetListActiveGroupByViewType(PackViewType.MASTER_BLACKSMITH)
    if listGroupProductConfig:Count() > 0 then
        local hasAvailableGroup = true
        for i = 1, listGroupProductConfig:Count() do
            --- @type GroupProductConfig
            local groupProductConfig = listGroupProductConfig:Get(i)
            local groupId = groupProductConfig.groupId
            local groupCreatedTime = progressPackCollection.activeProgressPackDict:Get(groupId)
            if (groupProductConfig.duration - (zg.timeMgr:GetServerTime() - groupCreatedTime)) > 0 then
                UIBaseView.CheckBlurMain(true, true, function()
                    PopupMgr.ShowPopup(UIPopupName.UISpecialOfferShop, { ["callbackClose"] = callbackClose })
                end)
                break
            else
                hasAvailableGroup = false
            end
        end
        if hasAvailableGroup == false then
            eventHasEnded()
        end
    else
        eventHasEnded()
    end
end

function UIMainAreaView:OnClickStarterPack(callbackClose)
    local eventHasEnded = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        self.config.buttonStarterPack.gameObject:SetActive(false)
    end
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    --- @type ProgressPackCollection
    local progressPackCollection = iapDataInBound.progressPackData
    local listGroupProductConfig = progressPackCollection:GetListActiveGroupByViewType(PackViewType.STARTER_PACK_NEW)
    if listGroupProductConfig:Count() > 0 then
        --- @type GroupProductConfig
        local groupProductConfig = listGroupProductConfig:Get(1)
        local groupId = groupProductConfig.groupId
        local groupCreatedTime = progressPackCollection.activeProgressPackDict:Get(groupId)
        if (groupProductConfig.duration - (zg.timeMgr:GetServerTime() - groupCreatedTime)) > 0 then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.FIRST_PURCHASE, "true")
            UIBaseView.CheckBlurMain(true, true, function()
                PopupMgr.ShowPopup(UIPopupName.UIStarterPackNew, { ["callbackClose"] = callbackClose })
            end)
        else
            eventHasEnded()
        end
    else
        eventHasEnded()
    end
end

function UIMainAreaView:OnClickTrialMonthlyCard()
    UIBaseView.CheckBlurMain(true, true, function()
        PopupMgr.ShowPopup(UIPopupName.UITrialMonthlyCard, { ["callbackClose"] = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UITrialMonthlyCard)
        end })
    end)
end

function UIMainAreaView:ShowAvatar()
    if self.iconVip == nil then
        self.iconVip = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.vipIconView)
        self.iconVip:AddListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            UIBaseView.CheckBlurMain(true, true, function()
                PopupMgr.ShowPopup(UIPopupName.UIUserProfile)
            end)
            zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
        end)
    end

    --- @type BasicInfoInBound
    local inbound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    if inbound == nil then
        XDebug.Error("basic info is nil")
    else
        self.iconVip:SetData(inbound.avatarData:GetAvatar(), inbound.level, inbound.avatarData:GetFrame())
        ---@type string
        local name = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).name
        self.config.textName.text = name:len() >= 15 and name:sub(1, 12) .. "..." or name
    end
end

function UIMainAreaView:ShowVip()
    ---@type number
    local currentVip = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).vipLevel
    self.config.imageVip.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconVip, currentVip)
    self.config.imageVip:SetNativeSize()
end

function UIMainAreaView:ShowExpBar()
    self.config.textLvl.text = string.format("Lv.%s", zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level)

    -- EXP progress bar
    if zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level < ResourceMgr.GetMainCharacterConfig().mainCharacterExpDictionary:Count() then
        ---@type MainCharacterExpConfig
        local mainCharacterExp = ResourceMgr.GetMainCharacterConfig().mainCharacterExpDictionary:Get(zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level + 1)
        local exp = InventoryUtils.Get(ResourceType.SummonerExp, 0)
        self.config.textExpBarProgress.text = string.format("%d/%d", exp, mainCharacterExp.exp)
        self.config.expBarProgress.fillAmount = math.min(exp / mainCharacterExp.exp, 1)
    else
        self.config.textExpBarProgress.text = LanguageUtils.LocalizeCommon("max")
        self.config.expBarProgress.fillAmount = 1
    end
end

function UIMainAreaView:_OnClickShowQuest()
    local openQuest = function()
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "quest")
        UIBaseView.CheckBlurMain(true, true, function()
            PopupMgr.ShowPopup(UIPopupName.UIQuest)
        end)
    end
    QuestDataInBound.Validate(openQuest)
end

function UIMainAreaView:CheckNotificationChat()
    local chatData = zg.playerData:GetChatData()
    chatData.isHasNotifyMainMenu = false
    --- @param chatChanel ChatChanel
    --- @param lastMessageChannelReceived number
    for chatChanel, lastMessageChannelReceived in pairs(chatData.lastMessageChannelReceivedDict:GetItems()) do
        if ChatData.IsMainMenuChat(chatChanel) == true
                and ChatData.IsBlockChatChannel(chatChanel) == false
                and lastMessageChannelReceived > UIChatModel.GetLastTimeReadChannel(chatChanel) then
            chatData.isHasNotifyMainMenu = true
            break
        end
    end
    self.config.iconChatNew:SetActive(chatData.isHasNotifyMainMenu)

    --if chatDat.isHasNotifyMainMenu == false then
    --    ChatRequest.SubscribeChat()
    --end
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIMainAreaView:ShowTutorial(tutorial, step)
    self:CheckFocusTutorial()
    if step == TutorialStep.SUMMON_CLICK or step == TutorialStep.CONTINUE_SUMMON then
        --self.mainAreaWorld:ClampCameraPosition(self.mainAreaWorld.config.summonCircle.transform.position.x)
        tutorial:ViewFocusCurrentTutorial(self.mainAreaWorld:GetButtonBuilding(FeatureType.SUMMON), 1, function()
            return self.mainAreaWorld:GetBuildingPositionOnUI(self.mainAreaWorld.config.summonCircle.transform)
        end, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CAMPAIGN_CLICK then
        --self.mainAreaWorld:ClampCameraPosition(self.mainAreaWorld.config.campaign.transform.position.x)
        tutorial:ViewFocusCurrentTutorial(self.mainAreaWorld:GetButtonBuilding(FeatureType.CAMPAIGN), 1, function()
            return self.mainAreaWorld:GetBuildingPositionOnUI(self.mainAreaWorld.config.campaign.transform)
        end, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.BLACK_MARKET_CLICK then
        --self.mainAreaWorld:ClampCameraPosition(self.mainAreaWorld.config.blackmarket.transform.position.x)
        tutorial:ViewFocusCurrentTutorial(self.mainAreaWorld:GetButtonBuilding(FeatureType.BLACK_MARKET), 1, function()
            return self.mainAreaWorld:GetBuildingPositionOnUI(self.mainAreaWorld.config.blackmarket.transform)
        end, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CLICK_BLACK_SMITH then
        --self.mainAreaWorld:ClampCameraPosition(self.mainAreaWorld.config.blacksmith.transform.position.x)
        tutorial:ViewFocusCurrentTutorial(self.mainAreaWorld:GetButtonBuilding(FeatureType.BLACK_SMITH), 1, function()
            return self.mainAreaWorld:GetBuildingPositionOnUI(self.mainAreaWorld.config.blacksmith.transform)
        end, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CLICK_HERO_COLLECTION then
        tutorial:ViewFocusCurrentTutorial(self.config.heroList, 0.4, nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CLICK_QUEST then
        tutorial:ViewFocusCurrentTutorial(self.config.quest, 0.5, nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CLICK_SUMMONER then
        tutorial:ViewFocusCurrentTutorial(self.config.summoner, 0.4, nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CLICK_INVENTORY then
        tutorial:ViewFocusCurrentTutorial(self.config.inventory, 0.4, nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CLICK_RENAME then
        PopupMgr.ShowPopup(UIPopupName.UIRename, { ["notClose"] = true })
    elseif step == TutorialStep.CLICK_GO then
        zg.playerData:GetQuest().questTreeDataInBound.isCollapsed = false
        self.callbackDoneDataQuest = function()
            tutorial:ViewFocusCurrentTutorial(self.uiMiniQuestTreeView.config.buttonGo, 0.4, nil, nil, TutorialHandType.CLICK)
        end
    elseif step == TutorialStep.CLICK_QUEST_COMPLETE then
        zg.playerData:GetQuest().questTreeDataInBound.isCollapsed = false
        self.callbackDoneDataQuest = function()
            tutorial:ViewFocusCurrentTutorial(self.uiMiniQuestTreeView.config.buttonComplete, 0.4, nil, nil, TutorialHandType.CLICK)
        end
    elseif step == TutorialStep.SKIP_ALL_TUTORIAL then
        if zg.networkMgr.isLogin == true then
            TutorialData.SkipTut()
        end
    end
end

--- @return void
function UIMainAreaView:CheckFocusTutorial()
    if UIBaseView.IsActiveTutorial() == true then
        local step = UIBaseView.tutorial.currentTutorial.tutorialStepData.step
        if step == TutorialStep.SUMMON_CLICK or step == TutorialStep.CONTINUE_SUMMON then
            self.mainAreaWorld:ClampCameraPosition(self.mainAreaWorld.config.summonCircle.transform.position.x)
        elseif step == TutorialStep.CAMPAIGN_CLICK then
            self.mainAreaWorld:ClampCameraPosition(self.mainAreaWorld.config.campaign.transform.position.x)
        elseif step == TutorialStep.BLACK_MARKET_CLICK then
            self.mainAreaWorld:ClampCameraPosition(self.mainAreaWorld.config.blackmarket.transform.position.x)
        elseif step == TutorialStep.CLICK_BLACK_SMITH then
            self.mainAreaWorld:ClampCameraPosition(self.mainAreaWorld.config.blacksmith.transform.position.x)
        end
    end
end

function UIMainAreaView:OnHideLoading()
    --self.config.anim:Play()
    if self.uiMiniQuestTreeView ~= nil
            and self.uiMiniQuestTreeView:IsActiveSelf() == true then
        self.uiMiniQuestTreeView:SetCollapseState(true)
    end
end

function UIMainAreaView:CheckShowFragment()
    self.config.notiInventory:SetActive(false)
end

function UIMainAreaView:CheckVisualFeatureStateUpdated()
    if FeatureConfigInBound.VISUAL_UPDATED == true then
        return
    end
    self:CheckFeatureButtonByConfigServer()
    self.mainAreaWorld:CheckShowFeatureIcon()
    FeatureConfigInBound.VISUAL_UPDATED = true
end

function UIMainAreaView:CheckFeatureUnlockButton()
    local level = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
    if self.model.lastLevelCheck == level and self.model.lastCampaignStageCheck == zg.playerData:GetCampaignData().stageCurrent then
        return
    end
    self.config.inventory.gameObject:SetActive(ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.INVENTORY, false))
    self.config.summoner.gameObject:SetActive(ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.SUMMONER, false))

    self.config.mastery.gameObject:SetActive(ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.MASTERY, false))
    --self.config.friend.gameObject:SetActive(ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.FRIENDS, false))
    self.config.handOfMidas.gameObject:SetActive(ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.HAND_OF_MIDAS, false))

    self.model.lastLevelCheck = level
    self.model.lastCampaignStageCheck = zg.playerData:GetCampaignData().stageCurrent

    self:CheckFeatureButtonByConfigServer()
end

function UIMainAreaView:CheckFeatureButtonByConfigServer()
    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    local checkFeatureState = function(featureType, button)
        local validMajorFeatureCondition = ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(featureType, false)
        --- @type FeatureItemInBound
        local featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(featureType)
        button.gameObject:SetActive(validMajorFeatureCondition and featureItemInBound:IsAvailableToShowButton())
    end
    checkFeatureState(FeatureType.RAISE_LEVEL, self.config.raiseLevel)
end

--- @param data table
---{['resourceType'] = self.type, ['resourceId'] = resourceId, ['quantity'] = quantity, ['result'] = self._resourceDict:Get(resourceId)})
function UIMainAreaView:CheckNotificationOnChangeResource(data)
    if data.resourceType == ResourceType.Money then
        local moneyType = data.resourceId
        if moneyType == MoneyType.SUMMONER_ANCIENT_BOOK then
            self:CheckNotificationSummoner()
        elseif moneyType == MoneyType.ARENA_MARKET_UPGRADE_COIN or
                moneyType == MoneyType.BLACK_MARKET_UPGRADE_COIN then
            self:CheckNotificationModeShop()
        elseif moneyType == MoneyType.GUILD_MARKET_UPGRADE_COIN then
            self:CheckNotificationGuild()
        else
            -- dont support
        end
    end
end

function UIMainAreaView:CheckNotificationGuild()
    self.mainAreaWorld:EnableFeatureNotify(FeatureType.GUILD, false)
    local result = function(isNotified)
        self.mainAreaWorld:EnableFeatureNotify(FeatureType.GUILD, isNotified)
    end
    NotificationCheckUtils.CheckNotificationGuild(result)
end

function UIMainAreaView:CheckNotificationDomains()
    self.mainAreaWorld:EnableFeatureNotify(FeatureType.DOMAINS, false)
    local result = function(isNotified)
        self.mainAreaWorld:EnableFeatureNotify(FeatureType.DOMAINS, isNotified)
    end
    NotificationCheckUtils.CheckNotificationDomains(result)
end

function UIMainAreaView:CheckOpenMiniQuestTree(fixedCollapsed, doneCheckCallback)
    local openMiniQuestTree = function()
        --- @type QuestDataInBound
        local questDataInBound = zg.playerData:GetQuest()
        --- @type {questUnitInBound : QuestUnitInBound, onClaimSuccess, isCollapsed}
        local data = {}
        --- @type number
        local selectedQuestId = questDataInBound.questTreeDataInBound:SelectQuestTreeToShowOnMiniPanel()
        if (selectedQuestId ~= nil) then
            --- @param loadedQuestData QuestUnitInBound
            local onLoadSelectedQuestSuccess = function(loadedQuestData)
                data.questUnitInBound = loadedQuestData
                data.onClaimSuccess = function()
                    self:CheckOpenMiniQuestTree(false)
                end
                data.isCollapsed = fixedCollapsed
                self:_ShowUIMiniQuestTree(data)
                if doneCheckCallback ~= nil then
                    doneCheckCallback(data.questUnitInBound)
                end
            end
            QuestDataInBound.RequestSelectedQuestData(selectedQuestId, QuestDataType.QUEST_TREE,
                    questDataInBound.questTreeDataInBound:GetQuestElementConfig(selectedQuestId),
                    onLoadSelectedQuestSuccess)
        else
            if self.uiMiniQuestTreeView ~= nil then
                self.uiMiniQuestTreeView:Hide()
            end
        end
    end
    QuestDataInBound.Validate(openMiniQuestTree, false)
end

--- @param data {questUnitInBound : QuestUnitInBound, onClaimSuccess, isCollapsed}
function UIMainAreaView:_ShowUIMiniQuestTree(data)
    if self.uiMiniQuestTreeView == nil then
        self.uiMiniQuestTreeView = UIMiniQuestTreeView(self.config.popupMiniQuestTree)
    end
    self.uiMiniQuestTreeView:OnReadyShow(data)
end

function UIMainAreaView:CheckOpeningEventServerOpen()
    --- @type ServerOpenInBound
    local eventData = zg.playerData:GetMethod(PlayerDataMethod.SERVER_OPEN)
    self.config.eventServerOpen.gameObject:SetActive(eventData ~= nil and eventData.hasData)
    if eventData == nil or eventData.hasData == false then
        return
    end

    zg.timeMgr:AddUpdateFunction(self.updateTimeServerOpen)
    local check = function()
        require "lua.client.scene.ui.notification.NotificationEventServerOpen"
        NotificationEventServerOpen.CheckNotificationEventServerOpen(function(noti)
            self.config.notiEventServerOpen:SetActive(noti)
            if noti == false then
                if self.subscriptionQuestServerOpenComplete == nil then
                    self.subscriptionQuestServerOpenComplete = RxMgr.serverNotification:Filter(function(data)
                        return BitUtils.IsOn(data, ServerNotificationType.SERVER_OPEN_UPDATED)
                    end)                                            :Subscribe(function()
                        self.config.notiEventServerOpen:SetActive(true)
                    end)
                end
            end
        end)
    end
    --- @type ServerOpenInBound
    if eventData.hasQuestComplete == true then
        self.config.notiEventServerOpen:SetActive(true)
    else
        check()
    end
end

function UIMainAreaView:OnClickFirstTimeReward()
    UIBaseView.CheckBlurMain(true, true, function()
        PopupMgr.ShowPopup(UIPopupName.UIFirstTopUp, { ["callbackClose"] = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIFirstTopUp)
        end })
    end)
end

function UIMainAreaView:OnClickLunarPath()
    EventInBound.ValidateEventModel(function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventLunarPath, nil, UIPopupName.UIMainArea)
    end)
end

function UIMainAreaView:OnClickValentine()
    EventInBound.ValidateEventModel(function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventValentine, nil, UIPopupName.UIMainArea)
    end)
end

function UIMainAreaView:OnClickEventServerOpen()
    ServerOpenInBound.Validate(function()
        --- @type ServerOpenInBound
        local eventData = zg.playerData:GetMethod(PlayerDataMethod.SERVER_OPEN)
        if eventData.hasData then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.SERVER_OPEN, "show")
            UIBaseView.CheckBlurMain(true, true, function()
                PopupMgr.ShowPopup(UIPopupName.UIEventServerOpen)
            end)
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
    end)
end

function UIMainAreaView:OnClickSetting()
    ---@type AuthenticationInBound
    local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
    if authenticationInBound ~= nil and authenticationInBound.emailState ~= nil then
        UIBaseView.CheckBlurMain(true, true, function()
            PopupMgr.ShowPopup(UIPopupName.UIGeneralSetting)
        end)
    else
        AuthenticationInBound.Request(function()
            UIBaseView.CheckBlurMain(true, true, function()
                PopupMgr.ShowPopup(UIPopupName.UIGeneralSetting)
            end)
        end)
    end
end

function UIMainAreaView:OnClickVip()
    --- @return void
    PopupMgr.ShowPopup(UIPopupName.UIVipNew)
end

function UIMainAreaView:CheckNotiBindingAccount()
    local campaignData = zg.playerData:GetCampaignData()
    ---@type AuthenticationInBound
    local authenticationInBound = zg.playerData:GetMethod(PlayerDataMethod.AUTHENTICATION)
    if campaignData.stageCurrent >= 102015
            and zg.playerData.remoteConfigAccount.notiBindAccount ~= true
            and zg.playerData.remoteConfigAccount.notiBindAccount ~= true
            and authenticationInBound:IsAccountBinding() == false then
        zg.playerData.remoteConfigAccount.notiBindAccount = true
        zg.playerData:SaveRemoteConfigAccount()
        local canClose = false
        Coroutine.start(function()
            coroutine.waitforseconds(2)
            canClose = true
        end)
        PopupUtils.ShowPopupNotificationOneButton(LanguageUtils.LocalizeCommon("noti_binding_account"), function()
            self:OnClickSetting()
        end, nil, false, 2,
                "binding_account_now", true,
                function()
                    if canClose == true then
                        PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
                    end
                end)
    end
end
function UIMainAreaView:CheckStarterPackNoti()
    local noti = false
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    local progressPackData = iapDataInBound.progressPackData
    if (progressPackData == nil) then
        noti = true
    end
    noti = progressPackData:HasPackNotChoose()
    self.config.notificationStarterPack.gameObject:SetActive(noti)
end

function UIMainAreaView:CheckFirstTimeRewardNoti()
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    local showNoti = iapDataInBound:HasRewardNotChoosen()
    --XDebug.Log("show noti " .. tostring(showNoti))

    --[[    ---@type boolean
        local alreadyChoosePack = IapDataInBound.AlreadyChoosePack()
        self.config.notiFirstTimeReward:SetActive(not alreadyChoosePack)]]
    self.config.notiFirstTimeReward:SetActive(showNoti)
end

function UIMainAreaView:CheckActiveFirstTimeRewardBtn()
    ---@type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    local isActiveFirstTimeReward = not iapDataInBound:HasClaimedAllFirstTopUPReward()
    self.config.firstTimeReward.gameObject:SetActive(isActiveFirstTimeReward)
    if isActiveFirstTimeReward then
        --- @type HeroSummonInBound
        local server = zg.playerData:GetMethod(PlayerDataMethod.SUMMON)
        local firstTopUpDataId = server:GetFirstTopUpDataId()

        if firstTopUpDataId > 0 then
            self.config.icon1stReward.gameObject:SetActive(false)
            self.config.icon1stRewardAbTest.gameObject:SetActive(true)
            self.config.icon1stRewardAbTest.sprite = ResourceLoadUtils.LoadFirstTopUpIcon(firstTopUpDataId)
        else
            self.config.icon1stReward.gameObject:SetActive(true)
            self.config.icon1stRewardAbTest.gameObject:SetActive(false)
        end
    end
end

function UIMainAreaView:OnDestroy()
    U_Object.Destroy(self.mainAreaWorld.gameObject)
end

function UIMainAreaView:ShowAppleReviewIap()
    self.config.firstPurchase.gameObject:SetActive(false)
    self.config.firstPurchaseFake1.gameObject:SetActive(true)
    self.config.firstPurchaseFake2.gameObject:SetActive(true)
    self.config.firstPurchaseFake3.gameObject:SetActive(true)
    if zg.playerData.fakePurchase == nil then
        require "lua.client.core.network.fake.FakeDataRequest"
        FakeDataRequest.FakeFlashSalePurchase(1)
        FakeDataRequest.FakeStarterPackPurchase(1)
        zg.playerData.fakePurchase = true
    end
end

function UIMainAreaView:OnClickBackOrClose()
    self:OnReadyHide()
end

function UIMainAreaView:OnClickEventNewHero()
    local doneValidate = function()
        UIBaseView.CheckBlurMain(true, true, function()
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "event_new_hero")
            PopupMgr.ShowPopup(UIPopupName.UIEventNewHero)
        end)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventMergeServer()
    local doneValidate = function()
        UIBaseView.CheckBlurMain(true, true, function()
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "event_merge_server")
            PopupMgr.ShowPopup(UIPopupName.UIEventMergeServer)
        end)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventEasterEgg()
    local doneValidate = function()
        UIBaseView.CheckBlurMain(true, true, function()
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "event_easter_egg")
            PopupMgr.ShowPopup(UIPopupName.UIEventEasterEgg)
        end)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickWelcomeBack()
    WelcomeBackInBound.Validate(function()
        UIBaseView.CheckBlurMain(true, true, function()
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "welcome_back")
            PopupMgr.ShowPopup(UIPopupName.UIWelcomeBack)
        end)
    end)
end

function UIMainAreaView:OnClickBirthday()
    local doneValidate = function()
        UIBaseView.CheckBlurMain(true, true, function()
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "birthday")
            PopupMgr.ShowPopup(UIPopupName.UIEventBirthday)
        end)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventSkinBundle()
    local doneValidate = function()
        UIBaseView.CheckBlurMain(true, true, function()
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "skin_bundle")
            PopupMgr.ShowPopup(UIPopupName.UIEventSkinBundle)
        end)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventHeroRelease()
    local doneValidate = function()
        UIBaseView.CheckBlurMain(true, true, function()
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "hero_release")
            PopupMgr.ShowPopup(UIPopupName.UIEventHeroRelease)
        end)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventHeroReleaseSummon()
    local doneValidate = function()
        UIBaseView.CheckBlurMain(true, true, function()
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "summon_hero_release")
            PopupMgr.ShowPopup(UIPopupName.UIHeroSummonRemake)
        end)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickBattlePass()
    local doneValidate = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIBattlePass, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:FakeOnClickBattlePass()
    PopupMgr.ShowPopup(UIPopupName.UIBattlePass)
    PopupMgr.HidePopup(UIPopupName.UIBattlePass)
end

function UIMainAreaView:OnClickNewServerWeek()
    local doneValidate = function()
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.SERVER_WEEK_1, "server_week1")
        PopupMgr.ShowAndHidePopup(UIPopupName.UINewServerWeek, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickNewServerWeekCheckIn()
    local doneValidate = function()
        local data = {}
        data.tab = NewServerWeekTab.DAILY
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.SERVER_WEEK_1, "server_week1")
        UIBaseView.CheckBlurMain(true, true, function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UINewServerWeek, data, self.model.uiName)
        end)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickNewServerWeek2()
    local doneValidate = function()
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.SERVER_WEEK_2, "server_week2")
        PopupMgr.ShowAndHidePopup(UIPopupName.UINewServerWeek2, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickNewServerWeek3()
    local doneValidate = function()
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.SERVER_WEEK_3, "server_week3")
        PopupMgr.ShowAndHidePopup(UIPopupName.UINewServerWeek3, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickIdleEffectBundle()
    local doneValidate = function()
        PopupMgr.ShowPopup(UIPopupName.UIEventIdleEffectBundle, nil)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventKazetsu()
    local doneValidate = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventKazetsu, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventKazetsuSummon()
    local doneValidate = function()
        UIBaseView.CheckBlurMain(true, true, function()
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "summon_hero_release")
            PopupMgr.ShowPopup(UIPopupName.UIHeroSummonRemake)
        end)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventNewHeroRateUpSummon()
    local doneValidate = function()
        UIBaseView.CheckBlurMain(true, true, function()
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "summon_hero_release")
            PopupMgr.ShowPopup(UIPopupName.UIHeroSummonRemake)
        end)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventFindeBoss()
    local doneValidate = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventHeroBoss, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventPuzzle()
    local doneValidate = function()
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "event_puzzle")
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventPuzzle, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventZodiac()
    local doneValidate = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventZodiac, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventSkinChallenge()
    local doneValidate = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventSkinChallenge, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventNewVip()
    local doneValidate = function()
        PopupMgr.ShowPopup(UIPopupName.UIEventNewVip)
    end
    EventInBound.ValidateEventModel(doneValidate, true)
end

function UIMainAreaView:OnClickEventAiryuu()
    local doneValidate = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventAiryuu, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventTowerOfEitri()
    local doneValidate = function()
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "event_dragon_tower")
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventTowerOfEitri, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventSeasonal()
    local doneValidate = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventSeasonal, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventBossChallenge()
    local doneValidate = function()
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "event_boss_challenge")
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventBossChallenge, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventPieceAdventure()
    local doneValidate = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventPieceAdventure, nil, self.model.uiName)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventBlackFridayNewVersion()
    local doneValidate = function()
        local data = {}
        data.callbackClose = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIEventBlackFridayNewVersion)
        end
        PopupMgr.ShowPopup(UIPopupName.UIEventBlackFridayNewVersion, data)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventThanksGiving()
    local doneValidate = function()
        local data = {}
        data.callbackClose = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIEventThankGiving)
        end
        PopupMgr.ShowPopup(UIPopupName.UIEventThankGiving, data)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventEasterDay()
    local doneValidate = function()
        local data = {}
        data.callbackClose = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIEventEasterDay)
        end
        PopupMgr.ShowPopup(UIPopupName.UIEventEasterDay, data)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventSummerDay()
    local doneValidate = function()
        local data = {}
        data.callbackClose = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIEventSummerDay)
        end
        PopupMgr.ShowPopup(UIPopupName.UIEventSummerDay, data)
    end
    EventInBound.ValidateEventModel(doneValidate)
end

function UIMainAreaView:OnClickEventChristmas()
    local openEvent = function()
        --- @type EventChristmasModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_CHRISTMAS)
        if eventModel:IsOpening() then
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "event_chrismas")
            PopupMgr.ShowAndHidePopup(UIPopupName.UIEventChristmas, nil, UIPopupName.UIMainArea)
        else
            self.config.buttonEventChristmas.gameObject:SetActive(false)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        end
    end
    EventInBound.ValidateEventModel(openEvent)
end

function UIMainAreaView:OnClickEventNewYear2023()
    local openEvent = function()
        --- @type EventChristmasModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR_2023)
        if eventModel:IsOpening() then
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "event_newyear")
            PopupMgr.ShowAndHidePopup(UIPopupName.UIEventNewYear2023, nil, UIPopupName.UIMainArea)
        else
            self.config.buttonEventNewYear2023.gameObject:SetActive(false)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        end
    end
    EventInBound.ValidateEventModel(openEvent)
end

function UIMainAreaView:OnClickEventQixiFestival()
    local openEvent = function()
        --- @type EventQixiFestivalModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_QIXI)
        if eventModel:IsOpening() then
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "event_qixi")
            PopupMgr.ShowAndHidePopup(UIPopupName.UIEventQixiFestival, nil, UIPopupName.UIMainArea)
        else
            self.config.buttonEventQixiFestival.gameObject:SetActive(false)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        end
    end
    EventInBound.ValidateEventModel(openEvent)
end

function UIMainAreaView:OnClickEventBlossomDay()
    local openEvent = function()
        --- @type EventBlossomDayModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLOSSOM)
        if eventModel:IsOpening() then
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, "event_blossom_day")
            PopupMgr.ShowAndHidePopup(UIPopupName.UIEventBlossomDay, nil, UIPopupName.UIMainArea)
        else
            self.config.buttonEventBlossomDay.gameObject:SetActive(false)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        end
    end
    EventInBound.ValidateEventModel(openEvent)
end

function UIMainAreaView:OnClickEventLunarNewYear2024()
    local openEvent = function()
        --- @type EventLunarNewYear2024Model
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2024)
        if eventModel:IsOpening() then
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, FBEvents.EVENT_LUNAR_NEW_YEAR_2024)
            PopupMgr.ShowAndHidePopup(UIPopupName.UIEventLunarNewYear2024, nil, UIPopupName.UIMainArea)
        else
            self.config.buttonEventLunarNewYear2024.gameObject:SetActive(false)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        end
    end
    EventInBound.ValidateEventModel(openEvent)
end

function UIMainAreaView:OnClickEventMayDay()
    local openEvent = function()
        --- @type EventMayDayModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MAY_DAY)
        if eventModel:IsOpening() then
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, FBEvents.EVENT_MAY_DAY)
            PopupMgr.ShowAndHidePopup(UIPopupName.UIEventMayDay, nil, UIPopupName.UIMainArea)
        else
            self.config.buttonEventMayDay.gameObject:SetActive(false)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        end
    end
    EventInBound.ValidateEventModel(openEvent)
end

function UIMainAreaView:OnClickEventValentine2024()
    local openEvent = function()
        --- @type EventValentine2024Model
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_VALENTINE_2024)
        if eventModel:IsOpening() then
            TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_MAP, FBEvents.EVENT_VALENTINE_2024)
            PopupMgr.ShowAndHidePopup(UIPopupName.UIEventValentine2024, nil, UIPopupName.UIMainArea)
        else
            self.config.buttonEventValentine2024.gameObject:SetActive(false)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        end
    end
    EventInBound.ValidateEventModel(openEvent)
end

function UIMainAreaView:OnClickEventDailyQuestPass()
    local openQuest = function()
        local data = {}
        data.tabIndex = 4
        TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "quest")
        UIBaseView.CheckBlurMain(true, true, function()
            PopupMgr.ShowPopup(UIPopupName.UIQuest, data)
        end)
    end
    QuestDataInBound.Validate(openQuest)
end

function UIMainAreaView:OnClickBoostFirstPurchase()
    UIBaseView.CheckBlurMain(true, true, function()
        PopupMgr.ShowPopup(UIPopupName.UIBoostFirstPurchase)
    end)
end

function UIMainAreaView:OnClickFlashSaleEvolve()
    local data = {}
    data.callbackClose = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIFlashSaleEvolve)
    end
    data.groupActive = zg.playerData:GetMethod(PlayerDataMethod.IAP).GetFlashSaleEvolveActiveGroup().groupActive
    UIBaseView.CheckBlurMain(true, true, function()
        PopupMgr.ShowPopup(UIPopupName.UIFlashSaleEvolve, data)
    end)
end

function UIMainAreaView:CheckEnableEventBattlePass()
    --- @type EventBattlePassModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    self.config.battlePass.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.notificationBattlePass.gameObject:SetActive(eventModel:HasNotification())
        local dataId = ClientConfigUtils.GetBattlePassSeasonOptimizeId(eventModel.timeData.dataId)
        self.config.iconBattlePassEvent.sprite = ResourceLoadUtils.LoadSpriteFromAtlas("IconEventBattlePass", dataId, ComponentName.UnityEngine_Sprite)
        self.config.iconBattlePassEvent:SetNativeSize()
    end
end

function UIMainAreaView:CheckEnableEventNewServerWeek()
    --- @type EventNewServerWeekModel
    local eventModel1 = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK)
    local eventModel2 = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SERVER_OPEN_SPIN)
    local eventModel3 = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SERVER_OPEN_ARENA)
    local isOpening = (eventModel1 ~= nil and eventModel1.timeData:IsOpening())
            or (eventModel2 ~= nil and eventModel2.timeData:IsOpening())
            or (eventModel3 ~= nil and eventModel3.timeData:IsOpening())
    self.config.newServerWeek.gameObject:SetActive(isOpening)
    self.config.newServerWeekCheckin.gameObject:SetActive(eventModel1 ~= nil and eventModel1.timeData:IsOpening())
    if isOpening then
        local hasNotification = (eventModel1 ~= nil and eventModel1:HasNotification())
                or (eventModel2 ~= nil and eventModel2:HasNotification())
                or (eventModel3 ~= nil and eventModel3:HasNotification())
        self.config.notificationNewServerWeek.gameObject:SetActive(hasNotification)
        self.config.notificationNewServerWeekCheckin.gameObject:SetActive(eventModel1:HasDailyDoneNotClaimed())
    end
end

function UIMainAreaView:CheckEnableEventNewServerWeek2()
    --- @type EventNewServerWeekModel
    local eventModel1 = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK_2)
    local eventModel3 = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SERVER_OPEN_ARENA_3V3)
    local isOpening = (eventModel1 ~= nil and eventModel1.timeData:IsOpening())
            or (eventModel3 ~= nil and eventModel3.timeData:IsOpening())
    self.config.newServerWeek2.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel1 ~= nil and eventModel1:HasNotification())
                or (eventModel3 ~= nil and eventModel3:HasNotification())
        self.config.notificationNewServerWeek2.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventNewServerWeek3()
    --- @type EventNewServerWeekModel
    local eventModel1 = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK_3)
    local isOpening = (eventModel1 ~= nil and eventModel1.timeData:IsOpening())
    self.config.newServerWeek3.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel1 ~= nil and eventModel1:HasNotification())
        self.config.notificationNewServerWeek3.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventIdleEffect()
    --- @type EventIdleEffectModel
    local eventModel1 = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_IDLE_EFFECT_BUNDLE)
    local isOpening = (eventModel1 ~= nil and eventModel1.timeData:IsOpening())
    self.config.idleEffectBundle.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel1 ~= nil and eventModel1:HasPackNotChosen())
        self.config.notificationIdleEffect.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventKazetsu()
    --- @type EventKazetsuModel
    local eventModel1 = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
    local isOpening = (eventModel1 ~= nil and eventModel1.timeData:IsOpening())
    self.config.eventKazetsu.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel1 ~= nil and eventModel1:HasNotification())
        self.config.notificationEventKazetsu.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventKazetsuSummon()
    --- @type EventKazetsuModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    self.config.buttonEventKazetsuSummon.gameObject:SetActive(isOpening)
    if isOpening then
        self.config.iconEventKazetsuSummon:SetNativeSize()
        self.config.notificationEventKazetsuSummon.gameObject:SetActive(eventModel:HasFreeSummon())
    end
end

function UIMainAreaView:CheckEnableEventRateUpSummon()
    --- @type EventNewHeroRateUpModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_RATE_UP)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    self.config.buttonEventNewHeroRateupSummon.gameObject:SetActive(isOpening)
    if isOpening then
        local dataId = eventModel.timeData.dataId
        self.config.notificationEventNewHeroRateupSummon.gameObject:SetActive(eventModel:IsAvailableFreeSummon())

        self.config.iconEventNewHeroRateupSummon.sprite = ResourceLoadUtils.LoadTexture("IconEventNewHeroRateupSummon", tonumber(dataId), ComponentName.UnityEngine_Sprite)
        self.config.iconEventNewHeroRateupSummon:SetNativeSize()
        self.config.textEventNewHeroRateupSummon.text = LanguageUtils.LocalizeCommon("event_new_hero_rateup_summon_" .. dataId)
    end
end

function UIMainAreaView:CheckEnableEventFindeBoss()
    --- @type EventFindeBossModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_FINDE_BOSS)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    self.config.buttonEventFindeBoss.gameObject:SetActive(isOpening)
    if isOpening then
        local dataId = eventModel.timeData.dataId

        self.config.iconEventFindeBoss.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconEventHeroBoss, tonumber(dataId))
        self.config.iconEventFindeBoss:SetNativeSize()
        self.config.textEventFindeBoss.text = LanguageUtils.LocalizeCommon("event_hero_boss_" .. dataId)
    end
end

function UIMainAreaView:CheckEnableEventPuzzle()
    --- @type EventPuzzleModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_PUZZLE)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventPuzzle.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventPuzzle.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventZodiac()
    --- @type EventZodiacModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_ZODIAC)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventZodiac.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventZodiac.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventSkinChallenge()
    --- @type EventSkinChallengeModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_CHALLENGE)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventSkinChallenge.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventSkinChallenge.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventNewVip()
    --- @type EventNewVipModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_VIP)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventNewVip.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventNewVip.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventAiryuu()
    --- @type EventAiryuuModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_AIRYUU)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventAiryuu.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventAiryuu.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventTowerOfEitri()
    --- @type EventTowerOfEitriModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_TOWER_OF_EITRI)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventTowerOfEitri.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventTowerOfEitri.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventSeasonal()
    --- @type EventSeasonalModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SEASONAL)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventSeasonal.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventSeasonal.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventBossChallenge()
    --- @type EventBossChallengeModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventBossChallenge.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventBossChallenge.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventPieceAdventure()
    --- @type EventPieceAdventureModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_PIECE_ADVENTURE)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventPieceAdventure.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventPieceAdventure.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventBlackFridayNewVersion()
    --- @type EventBlackFridayNewVersionModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY_SALE)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventBlackFridayNewVersion.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventBlackFridayNewVersion.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventThanksGiving()
    --- @type EventThankGivingModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_THANKS_GIVING)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventThanksGiving.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventThanksGiving.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventChristmas()
    --- @type EventThankGivingModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_CHRISTMAS)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventChristmas.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventChristmas.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventNewYear2023()
    --- @type EventNewYear2023Model
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR_2023)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventNewYear2023.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventNewYear2023.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventLunarNewYear2024()
    --- @type EventLunarNewYear2024Model
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2024)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventLunarNewYear2024.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventLunarNewYear2024.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventValentine2024()
    --- @type EventValentine2024Model
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_VALENTINE_2024)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventValentine2024.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventValentine2024.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventDailyQuestPass()
    --- @type EventDailyQuestPassModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_DAILY_QUEST_PASS)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventDailyQuestPass.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventDailyQuestPass.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventEasterDay()
    --- @type EventEasterDayModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_DAY)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventEasterDay.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventEasterDay.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventSummerDay()
    --- @type EventSummerDayModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SUMMER_DAY)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventSummerDay.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventSummerDay.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventBlossomDay()
    --- @type EventBlossomDayModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLOSSOM)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventBlossomDay.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventBlossomDay.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventQixiFestival()
    --- @type EventQixiFestivalModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_QIXI)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventQixiFestival.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventQixiFestival.gameObject:SetActive(hasNotification)
    end
end

function UIMainAreaView:CheckEnableEventMayDay()
    --- @type EventMayDayModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MAY_DAY)
    local isOpening = (eventModel ~= nil and eventModel.timeData:IsOpening())
    self.config.buttonEventMayDay.gameObject:SetActive(isOpening)
    if isOpening then
        local hasNotification = (eventModel ~= nil and eventModel:HasNotification())
        self.config.notificationEventMayDay.gameObject:SetActive(hasNotification)
    end
end