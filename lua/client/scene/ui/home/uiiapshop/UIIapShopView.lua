require "lua.client.scene.ui.home.uiIapShop.iapShopItem.IapShopTabItem"
require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.UIIapShopLayout"
require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.UIIapShopLimitedPackLayout"

--- @class UIIapShopView : UIBaseView
UIIapShopView = Class(UIIapShopView, UIBaseView)

--- @return void
--- @param model UIIapShopModel
function UIIapShopView:Ctor(model)
    --- @type UIIapShopConfig
    self.config = nil

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIIapShopLayout
    self.layout = nil

    --- @type Dictionary
    self.tabDict = Dictionary()

    --- @type number
    self.currentTab = nil

    ---@type Dictionary()
    self.levelTabDict = Dictionary()
    --- @type UILoopScroll
    self.verticalScroll = nil
    UIBaseView.Ctor(self, model)
    --- @type UIIapShopModel
    self.model = model
end

--- @return void
function UIIapShopView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtonListener()
    self:InitTab()
    uiCanvas:SetBackgroundSize(self.config.backGround)

    self:InitTime()
end

function UIIapShopView:InitTime()
    --- @type List<IapShopTabItem>
    local tabHasTime = List()
    --- @param v IapShopTabItem
    for k, v in pairs(self.tabDict:GetItems()) do
        if v.hasTimer then
            tabHasTime:Add(v)
        end
    end

    --- @param timeNextDay string
    self:InitUpdateTimeNextDay(function(timeNextDay, isSetTime)
        --if isSetTime then
        --- @param v IapShopTabItem
        for k, v in pairs(tabHasTime:GetItems()) do
            v:SetTime(timeNextDay)
        end
        --end
    end)
end

function UIIapShopView:InitButtonListener()
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonVip.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickVip()
    end)
end

function UIIapShopView:OnClickBackOrClose()
    self:OnReadyHide()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end

function UIIapShopView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIIapShopView:InitTab()
    for i = 1, self.config.contentShopTab.childCount do
        --- @type IapShopTabItem
        local tab = IapShopTabItem(self.config.contentShopTab:GetChild(i - 1))
        tab:SetListener(function()
            self:OnSelectTab(i)
        end)
        self.tabDict:Add(i, tab)
        if i == IapShopTab.LEVEL_PASS_1 then
            self.levelTabDict:Add(1, tab)
        elseif i == IapShopTab.LEVEL_PASS_2 then
            self.levelTabDict:Add(2, tab)
        end
    end
end

function UIIapShopView:CheckLevelPasses()
    --- @type LevelPassConfig
    local levelPassConfig = ResourceMgr.GetLevelPassConfig()
    --- @type IapShopTabItem
    for i, v in pairs(self.levelTabDict:GetItems()) do
        if levelPassConfig.lineConfig:IsContainKey(i) then
            ---@type GrowthPackLineConfig
            local data = levelPassConfig.lineConfig:Get(i)
            v:SetActive(not data:IsClaimCompleted())
        end
    end
end
function UIIapShopView:InitLocalization()
    --- @param v IapShopTabItem
    for k, v in pairs(self.tabDict:GetItems()) do
        v:SetTabName(self:GetTabName(k))
    end
    --- @param v UIIapShopLayout
    for k, v in pairs(self.layoutDict:GetItems()) do
        v:InitLocalization()
    end
end

--- @return string
--- @param iapShopTab IapShopTab
function UIIapShopView:GetTabName(iapShopTab)
    if iapShopTab == IapShopTab.MONTHLY_CARD then
        return LanguageUtils.LocalizeCommon("subscription_packs")
    elseif iapShopTab == IapShopTab.REGULAR_PACK then
        return LanguageUtils.LocalizeCommon("regular_pack")
    elseif iapShopTab == IapShopTab.LEVEL_PASS_1 then
        return string.format("%s %d", LanguageUtils.LocalizeCommon("level_pass"), 1)
    elseif iapShopTab == IapShopTab.LEVEL_PASS_2 then
        return string.format("%s %d", LanguageUtils.LocalizeCommon("level_pass"), 2)
    elseif iapShopTab == IapShopTab.ARENA_PASS then
        return LanguageUtils.LocalizeCommon("arena_pass")
    elseif iapShopTab == IapShopTab.RAW_PACK then
        return LanguageUtils.LocalizeCommon("raw_packs")
    elseif iapShopTab == IapShopTab.CUSTOMIZE_BUNDLE then
        return LanguageUtils.LocalizeCommon("customize_packs")
    elseif iapShopTab == IapShopTab.SKIN then
        return LanguageUtils.LocalizeCommon("skin")
    end
    return LanguageUtils.LocalizeCommon("raw_packs")
end

--- @param iapShopTab IapShopTab
function UIIapShopView:OnReadyShow(iapShopTab)
    self:InitListener()
    self:CheckActiveTabEventIap()

    if not iapShopTab then
        self:SetScrollPosition(0)
    end

    iapShopTab = iapShopTab or IapShopTab.MONTHLY_CARD
    self:OnSelectTab(iapShopTab)

    if iapShopTab == IapShopTab.SKIN or iapShopTab == IapShopTab.RAW_PACK then
        self:SetScrollPosition(600)
    end

    self:ShowVip()
    self:CheckAllNotification()
    self:CheckLevelPasses()
end

function UIIapShopView:SetScrollPosition(targetPosition)
    ---@type UnityEngine_Vector3
    local position = self.config.contentShopTab.position
    position.y = targetPosition
    self.config.contentShopTab.position = position
end

function UIIapShopView:CheckActiveTabEventIap()
    local checkActiveTabEvent = function(eventTimeType, iapShopTab)
        --- @type EventPopupModel
        local eventModel = zg.playerData:GetEvents():GetEvent(eventTimeType)
        --- @type IapShopTabItem
        local tabArenaPass = self.tabDict:Get(iapShopTab)
        tabArenaPass:SetActive(eventModel ~= nil and eventModel:IsOpening())
    end
    checkActiveTabEvent(EventTimeType.EVENT_ARENA_PASS, IapShopTab.ARENA_PASS)
end

--- @param iapShopTab IapShopTab
function UIIapShopView:EnableIapShopTab(iapShopTab, isEnable)
    --- @type IapShopTabItem
    local iapShopTabItem = self.tabDict:Get(iapShopTab)
    if iapShopTabItem ~= nil then
        iapShopTabItem:SetActive(isEnable)
    end
end

--- @return void
function UIIapShopView:InitListener()
    self.listener = RxMgr.vipLevelUp:Subscribe(function(vipLevel)
        self:ShowVip()
    end)
    self.subscriptionNotiFreeDeal = RxMgr.buyPackDealCompleted:Subscribe(function()
        if self.currentTab == IapShopTab.REGULAR_PACK then
            self:CheckShowNotificationRegularFreeDeal()
        end
    end)
end

--- @param iapShopTab IapShopTab
function UIIapShopView:OnSelectTab(iapShopTab)
    self.currentTab = iapShopTab
    --- @param v IapShopTabItem
    for k, v in pairs(self.tabDict:GetItems()) do
        v:SetTabState(k == iapShopTab)
    end
    self:GetLayout(iapShopTab)
    self.layout:OnShow(iapShopTab)
end

--- @param iapShopTab IapShopTab
function UIIapShopView:GetLayout(iapShopTab)
    self:DisableCommon()
    if self.layout ~= nil then
        self.layout:OnHide()
    end
    self.layout = self.layoutDict:Get(iapShopTab)
    if self.layout == nil then
        --- @return UIIapShopLevelPassLayout
        local initLevelPassLayout = function()
            require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopLevelPassLayout.UIIapShopLevelPassLayout"
            return UIIapShopLevelPassLayout(self, self.config.levelPassView)
        end
        if iapShopTab == IapShopTab.MONTHLY_CARD then
            require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopMonthlyCardLayout.UIIapShopMonthlyCardLayout"
            self.layout = UIIapShopMonthlyCardLayout(self, self.config.monthlyCardView)
        elseif iapShopTab == IapShopTab.REGULAR_PACK then
            require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopRegularLayout.UIIapShopRegularPackLayout"
            self.layout = UIIapShopRegularPackLayout(self, self.config.regularPackView)
        elseif iapShopTab == IapShopTab.LEVEL_PASS_1 then
            self.layout = self.layoutDict:Get(IapShopTab.LEVEL_PASS_2)
            if self.layout == nil then
                self.layout = initLevelPassLayout()
            end
        elseif iapShopTab == IapShopTab.LEVEL_PASS_2 then
            self.layout = self.layoutDict:Get(IapShopTab.LEVEL_PASS_1)
            if self.layout == nil then
                self.layout = initLevelPassLayout()
            end
        elseif iapShopTab == IapShopTab.ARENA_PASS then
            require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapPassLayout.UIIapPassLayout"
            self.layout = UIIapPassLayout(self, self.config.arenaPassView, EventTimeType.EVENT_ARENA_PASS)
            --elseif iapShopTab == IapShopTab.DAILY_QUEST_PASS then
            --    require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapPassLayout.UIIapPassLayout"
            --    require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapPassLayout.UIIapDailyQuestPassLayout"
            --    self.layout = UIIapDailyQuestPassLayout(self, self.config.dailyQuestPassView, EventTimeType.EVENT_DAILY_QUEST_PASS)
        elseif iapShopTab == IapShopTab.RAW_PACK then
            require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.UIIapShopRawPackLayout"
            self.layout = UIIapShopRawPackLayout(self, PackViewType.RAW_PACK)
        elseif iapShopTab == IapShopTab.CUSTOMIZE_BUNDLE then
            require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopCustomizeBundleLayout.UIIapShopCustomizeBundleLayout"
            self.layout = UIIapShopCustomizeBundleLayout(self, self.config.customizeBundleView)
        elseif iapShopTab == IapShopTab.SKIN then
            require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopSkinLayout.UIIapShopSkinLayout"
            self.layout = UIIapShopSkinLayout(self, self.config.skinShopView)
        else
            XDebug.Error("Missing layout of type " .. iapShopTab)
        end
        self.layout:InitLocalization()
        self.layoutDict:Add(iapShopTab, self.layout)
    end
end

function UIIapShopView:DisableCommon()
    self.config.monthlyCardView.gameObject:SetActive(false)
    self.config.scrollVertical.gameObject:SetActive(false)
    self.config.levelPassView.gameObject:SetActive(false)
    self.config.textTimer.gameObject:SetActive(false)
    self.config.bannerView.gameObject:SetActive(false)
    self.config.customizeBundleView.gameObject:SetActive(false)
end

function UIIapShopView:CheckAllNotification()
    self:CheckShowNotificationGrowthPack()
    self:CheckShowNotificationRegularFreeDeal()
    self:CheckNotificationArenaPass()
    self:CheckNotificationDailyQuestPass()
    self:CheckNotificationCustomBundle()
end

function UIIapShopView:CheckShowNotificationGrowthPack()
    --- @type IapShopTabItem
    local tabLevelLass1 = self.tabDict:Get(IapShopTab.LEVEL_PASS_1)
    tabLevelLass1:EnableNotify(false)
    --- @type IapShopTabItem
    local tabLevelLass2 = self.tabDict:Get(IapShopTab.LEVEL_PASS_2)
    tabLevelLass2:EnableNotify(false)

    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetIAP()
    --- @type GrowthPackCollection
    local growthPackCollection = iapDataInBound.growthPackData

    --- @type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)

    --- @param growthPackLineConfig GrowthPackLineConfig
    local checkActiveNotify = function(growthPackLineConfig)
        if growthPackLineConfig == nil then
            return false
        end
        return growthPackLineConfig:GetClaimableMilestone(basicInfoInBound.level,
                growthPackCollection:GetBoughtCount(growthPackLineConfig.line) > 0,
                growthPackCollection:GetGrowPatchLine(growthPackLineConfig.line)) ~= nil
    end
    --- @type GrowthPackLineConfig
    local growthPackLine1 = ResourceMgr.GetLevelPassConfig():GetGrowthPackConfigByLine(1)
    if checkActiveNotify(growthPackLine1, 1) then
        tabLevelLass1:EnableNotify(true)
    end
    --- @type GrowthPackLineConfig
    local growthPackLine2 = ResourceMgr.GetLevelPassConfig():GetGrowthPackConfigByLine(2)
    if checkActiveNotify(growthPackLine2) then
        tabLevelLass2:EnableNotify(true)
    end
end

function UIIapShopView:CheckNotificationArenaPass()
    --- @type IapShopTabItem
    local tabArenaPass = self.tabDict:Get(IapShopTab.ARENA_PASS)
    --- @type EventArenaPassModel
    local eventArenaPassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_ARENA_PASS)
    tabArenaPass:EnableNotify(eventArenaPassModel ~= nil and eventArenaPassModel:HasNotification())
end

function UIIapShopView:CheckShowNotificationRegularFreeDeal()
    --- @type IapShopTabItem
    local tabRegularPack = self.tabDict:Get(IapShopTab.REGULAR_PACK)
    local hasFreeDeal = false
    --- @param v IapShopRegularTabItem
    --- Check daily, weekly and monthly free deal
    for i = 1, 3 do
        hasFreeDeal = ResourceMgr.GetPurchaseConfig():GetCashShop():IsNotificationFrequentlyDeal(i)
        if hasFreeDeal then
            tabRegularPack:EnableNotify(hasFreeDeal)
            return
        end
    end
    tabRegularPack:EnableNotify(false)
end

function UIIapShopView:CheckNotificationDailyQuestPass()
    ----- @type IapShopTabItem
    --local tabArenaPass = self.tabDict:Get(IapShopTab.DAILY_QUEST_PASS)
    ----- @type EventDailyQuestPassModel
    --local eventDailyQuestPassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_DAILY_QUEST_PASS)
    --tabArenaPass:EnableNotify(eventDailyQuestPassModel ~= nil and eventDailyQuestPassModel:HasNotification())
end

function UIIapShopView:CheckNotificationCustomBundle()
    ----- @type IapDataInBound
    --local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    ----- @type CustomizePackStatisticsInBound
    --local package1 = iapDataInBound:GetCustomizePack(1)
    ----- @type CustomizePackStatisticsInBound
    --local package2 = iapDataInBound:GetCustomizePack(2)
    --
    ----- @type IapShopTabItem
    --local tab = self.tabDict:Get(IapShopTab.CUSTOMIZE_BUNDLE)
    --tab:EnableNotify(package1:ReachedLimit() == false or package2:ReachedLimit() == false)
end

function UIIapShopView:Hide()
    UIBaseView.Hide(self)
    if self.layout ~= nil then
        self.layout:OnHide()
    end
    self:RemoveListener()
end

function UIIapShopView:RemoveListener()
    if self.listener then
        self.listener:Unsubscribe()
        self.listener = nil
    end
    if self.subscriptionNotiDailyDeal then
        self.subscriptionNotiDailyDeal:Unsubscribe()
        self.subscriptionNotiDailyDeal = nil
    end
end

function UIIapShopView:ShowVip()
    ---@type number
    local currentVip = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).vipLevel
    self.config.iconVip.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconVip, currentVip)
    self.config.iconVip:SetNativeSize()
end

function UIIapShopView:OnClickVip()
    PopupMgr.ShowPopup(UIPopupName.UIVipNew)
end

