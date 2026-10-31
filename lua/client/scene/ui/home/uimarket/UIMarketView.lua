require "lua.client.scene.ui.home.uiMarket.UIButtonTabModeShop"
require "lua.client.core.network.market.MarketRequest"
require "lua.client.scene.ui.home.uiMarket.uiMarketLayout.UIMarketLayout"
require "lua.client.scene.ui.home.uiMarket.BgMarket"

--- @class UIMarketView : UIBaseView
UIMarketView = Class(UIMarketView, UIBaseView)

--- @return void
--- @param model UIMarketModel
function UIMarketView:Ctor(model)
    --- @type UIMarketConfig
    self.config = nil
    --- @type UISelect
    self.uiSelectPage = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    --- @type UISelect
    self.tab = nil
    --- @type function
    self.updateTime = nil
    --- @type ItemsTableView
    self.moneyTableView = nil
    --- @type MotionConfig
    self.motionConfig = MotionConfig(nil, nil, nil, 0.02, 3)
    --- @type boolean
    self.canPlayMotion = nil

    --- @type Dictionary | UIMarketLayout
    self.layoutDict = Dictionary()
    --- @type UIMarketLayout
    self.currentLayout = nil

    --- @type Dictionary | BgMarket
    self.bgMarketDict = Dictionary()
    --- @type BgMarket
    self.bgMarket = nil

    UIBaseView.Ctor(self, model)
    --- @type UIMarketModel
    self.model = model
    self.notifyDict = Dictionary()
end

function UIMarketView:OnReadyCreate()
    ---@type UIMarketConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitTab()
    self:_InitButtonListener()
    self:_InitItemTableView()
    self:_InitMoneyTableView()
    self:InitUiSelectPage()
end

function UIMarketView:_InitTab()
    --- @param obj UITabMarketPopupConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        obj.button.interactable = not isSelect
        obj.imageOn.gameObject:SetActive(isSelect)
    end

    --- @param indexTab MarketType
    local onChangeSelect = function(indexTab, lastTab)
        if self.currentLayout == nil or self.currentLayout.modeShopTab ~= indexTab then
            if indexTab == MarketType.BLACK_MARKET then
                self.config.moneyBarAnchor.localPosition = U_Vector3(88, -68, 0)
            else
                self.config.moneyBarAnchor.localPosition = U_Vector3(340, -68, 0)
            end
            self:ShowShopDataByTab(indexTab)
        end
    end
    self.tab = UISelect(self.config.buttonTabAnchor, UIBaseConfig, onSelect, onChangeSelect)
end

function UIMarketView:SetAllNotification()
    if self.marketInBound == nil then
        self.marketInBound = zg.playerData:GetMethod(PlayerDataMethod.MARKET)
    end
    if self.arenaInBound == nil then
        self.arenaInBound = zg.playerData:GetMethod(PlayerDataMethod.ARENA_MARKET)
    end
    if self.arenaTeamMarketInBound == nil then
        --- @type ModeShopDataInBound
        self.arenaTeamMarketInBound = zg.playerData:GetMethod(PlayerDataMethod.ARENA_TEAM_MARKET)
    end

    self.tab:GetButtonTabByIndex(MarketType.BLACK_MARKET).noti.gameObject:SetActive(self.marketInBound ~= nil and self.marketInBound:GetNotificationInView())
    self.tab:GetButtonTabByIndex(MarketType.ARENA_MARKET).noti.gameObject:SetActive(self.arenaInBound ~= nil and self.arenaInBound:GetNotificationInView())
    self.tab:GetButtonTabByIndex(MarketType.ARENA_TEAM_MARKET).noti.gameObject:SetActive(self.arenaTeamMarketInBound ~= nil and self.arenaTeamMarketInBound:GetNotificationInView())
end

--- @return UIMarketLayout
--- @param marketType MarketType
function UIMarketView:_GetLayout(marketType)
    self:HideLayout()
    self.currentLayout = self.layoutDict:Get(marketType)
    if self.currentLayout == nil then
        local tabAnchor
        if marketType ~= MarketType.GUILD_MARKET then
            tabAnchor = self.config.buttonTabAnchor:GetChild(marketType - 1)
        end
        if marketType == MarketType.BLACK_MARKET then
            require "lua.client.scene.ui.home.uiMarket.uiMarketLayout.UIBlackMarketLayout"
            self.currentLayout = UIBlackMarketLayout(self, marketType, tabAnchor)
        elseif marketType == MarketType.ALTAR_MARKET then
            require "lua.client.scene.ui.home.uiMarket.uiMarketLayout.UIAltarMarketLayout"
            self.currentLayout = UIAltarMarketLayout(self, marketType, tabAnchor)
        elseif marketType == MarketType.ARENA_MARKET then
            require "lua.client.scene.ui.home.uiMarket.uiMarketLayout.UIArenaMarketLayout"
            self.currentLayout = UIArenaMarketLayout(self, marketType, tabAnchor)
        elseif marketType == MarketType.ARENA_TEAM_MARKET then
            require "lua.client.scene.ui.home.uiMarket.uiMarketLayout.UIArenaTeamMarketLayout"
            self.currentLayout = UIArenaTeamMarketLayout(self, marketType, tabAnchor)
        elseif marketType == MarketType.EVENT_MARKET then
            --require "lua.client.scene.ui.home.uiMarket.uiMarketLayout.UIEventMarketLayout"
            --self.currentLayout = UIEventMarketLayout(self, marketType, tabAnchor)
            require "lua.client.scene.ui.home.uiMarket.uiMarketLayout.UIEventMarketNewVersionLayout"
            self.currentLayout = UIEventMarketNewVersionLayout(self, marketType, tabAnchor)
        elseif marketType == MarketType.DOMAINS_MARKET then
            require "lua.client.scene.ui.home.uiMarket.uiMarketLayout.UIDomainsMarketLayout"
            self.currentLayout = UIDomainsMarketLayout(self, marketType, tabAnchor)
        elseif marketType == MarketType.GUILD_MARKET then
            require "lua.client.scene.ui.home.uiMarket.uiMarketLayout.UIGuildMarketLayout"
            self.currentLayout = UIGuildMarketLayout(self, marketType)
        end

        self.currentLayout:InitLocalization()
        self.layoutDict:Add(marketType, self.currentLayout)
    end
end

--- @param result { marketType : MarketType, callbackClose }
function UIMarketView:OnReadyShow(result)
    self.canPlayMotion = true
    local marketType = MarketType.BLACK_MARKET
    if result ~= nil then
        marketType = result.marketType
    end
    self:CheckEnableArenaTeamShop()

    if marketType ~= MarketType.GUILD_MARKET then
        self.tab:Select(marketType)
        self:SetAllNotification()
    else
        self:_GetLayout(marketType)
        self.currentLayout:OnShow()
    end
end

function UIMarketView:CheckEnableArenaTeamShop()
    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    local featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(FeatureType.ARENA_TEAM)

    local tab = self.tab:GetButtonTabByIndex(MarketType.ARENA_TEAM_MARKET)
    tab.gameObject:SetActive(featureItemInBound.featureState == FeatureState.UNLOCK)
end

--- @return void
function UIMarketView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
end

--- @return void
function UIMarketView:InitLocalization()
    self.config.localizeRefresh.text = LanguageUtils.LocalizeCommon("refresh")
    if self.layoutDict ~= nil then
        --- @param v UIMarketLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIMarketView:OnClickBackOrClose()
    self:OnReadyHide()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end

function UIMarketView:Hide()
    UIBaseView.Hide(self)
    self:RemoveUpdateTime()
    self:HideItemsTableView()
    self.moneyTableView:Hide()
    self.model:OnHide()
    self:RemoveListenerTutorial()
    self:HideLayout()
end

function UIMarketView:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonTutorial.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonArrowLeft.onClick:AddListener(function()
        self:PreviousPage()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonArrowRight.onClick:AddListener(function()
        self:NextPage()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.refreshButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:_OnClickRefreshButton()
    end)
    if self:IsOpenNewShop() then
        self.config.upgradeLevelBtn.onClick:AddListener(function()
            self:OnClickUpgrade()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        end)
    end
end
--- @return boolean
function UIMarketView:IsOpenNewShop()
    return UIBaseView.IsActiveTutorial() == false and self.config.ugradingProcess ~= nil
end

function UIMarketView:_InitItemTableView()
    --- @param modeShopIconView ModeShopIconView
    local onInitItem = function(modeShopIconView)
        modeShopIconView:AddBuyListener(function()
            local cost = modeShopIconView.iconData.cost
            local yesCallback = function()
                local onBuySuccess = function()
                    if self.currentLayout ~= self.layoutDict:Get(MarketType.EVENT_MARKET) then
                        InventoryUtils.Sub(ResourceType.Money, cost.moneyType, cost.value)
                    end
                    SmartPoolUtils.ShowReward1Item(modeShopIconView.itemIconData)
                    self:_OnChangeSelect()
                    zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
                    RxMgr.mktTracking:Next(MktTrackingType.marketBuy, 1)
                end
                self.currentLayout:RequestBuyItem(modeShopIconView, onBuySuccess)
            end
            PopupUtils.ShowBuyItem(LanguageUtils.LocalizeCommon("want_to_buy"), cost, yesCallback)
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        end)
    end
    self.itemsTableView = ItemsTableView(self.config.gridItemAnchor, onInitItem, UIPoolType.ModeShopIconView)
end

function UIMarketView:_InitMoneyTableView()
    self.moneyTableView = ItemsTableView(self.config.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

--- @param marketType MarketType
function UIMarketView:ShowShopDataByTab(marketType)
    if self.currentLayout == nil or self.currentLayout.modeShopTab ~= marketType then
        self:_GetLayout(marketType)
        self.currentLayout:OnShow()
    end
end

function UIMarketView:HideLayout()
    self:DisableCommon()
    if self.currentLayout ~= nil then
        self.currentLayout:OnHide()
        self.currentLayout = nil
    end
end

function UIMarketView:_OnClickMoneyBar()
    XDebug.Log("On Click Money Bar")
end

function UIMarketView:_OnClickRefreshButton()
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_refresh_shop"), nil, function()
        self.currentLayout:OnClickButtonRefresh()
    end, nil)
end

function UIMarketView:OnClickUpgrade()
    self.currentLayout:OnClickUpgrade()
end

--- @param marketConfig MarketConfig
function UIMarketView:ShowRefreshPrice(marketConfig)
    self.config.iconCoinRefresh.sprite = ResourceLoadUtils.LoadMoneyIcon(marketConfig.refreshMoneyType)
    self.config.iconCoinRefresh:SetNativeSize()
    self:ShowRefreshPriceText(marketConfig)
end

--- @param marketConfig MarketConfig
function UIMarketView:ShowRefreshPriceText(marketConfig)
    self.config.refreshPrice.text = string.format("%s/%s", marketConfig.refreshPrice,
            ClientConfigUtils.FormatNumber(InventoryUtils.GetMoney(marketConfig.refreshMoneyType)))
end

--- @param pageCount number
function UIMarketView:SetUpButtonPage(pageCount)
    self.uiSelectPage:SetPagesCount(pageCount)
    self.uiSelectPage:Select(self.model.currentPage)
end

function UIMarketView:InitUiSelectPage()
    --- @param obj UIBlackMarketPageConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect)
        UIUtils.SetInteractableButton(obj.button, false)
        obj.imageOn:SetActive(isSelect)
    end

    --- @param indexTab number
    local onChangePage = function(indexTab, lastTab)
        if lastTab ~= nil and self.model.currentPage ~= indexTab then
            self.model.currentPage = indexTab
            self:_OnChangeSelect()
        end
    end
    self.uiSelectPage = UISelect(self.config.pageMarket, UIBaseConfig, onSelect, onChangePage)
end

function UIMarketView:SetUpMoneyBar(...)
    local args = { ... }
    local moneyList = List()
    for i = 1, #args do
        moneyList:Add(args[i])
    end
    self.moneyTableView:SetData(moneyList)
end

function UIMarketView:HideItemsTableView()
    self.itemsTableView:Hide()
end

function UIMarketView:_OnChangeSelect()
    self.currentLayout:OnChangePage()
    self.config.buttonArrowLeft.gameObject:SetActive(self.model.currentPage > 1)
    self.config.buttonArrowRight.gameObject:SetActive(self.model.currentPage < self.model.numberPage)
    self:CheckTutorial()
end

--- @param listDataItems List
function UIMarketView:SetDataItems(listDataItems)
    self.itemsTableView:SetData(listDataItems)
    self.config.buttonArrowLeft.gameObject:SetActive(self.model.currentPage > 1)
    self.config.buttonArrowRight.gameObject:SetActive(self.model.currentPage < self.model.numberPage)

    if self.canPlayMotion == true then
        self.itemsTableView:PlayMotion(self.motionConfig)
        self.canPlayMotion = false
    end
end

function UIMarketView:StartUpdateTime()
    self:RemoveUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIMarketView:RemoveUpdateTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

--- @return void
function UIMarketView:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("black_market_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIMarketView:ShowTutorial(tutorial, step)
    if step == TutorialStep.BUY_HEROIC_SCROLL then
        Coroutine.start(function()
            ---@type ModeShopIconView
            local shopIconView
            while shopIconView == nil do
                coroutine.waitforseconds(0.5)
                local iconList = self.itemsTableView:GetItems()
                ---@param v ModeShopIconView
                for _, v in ipairs(iconList:GetItems()) do
                    if v.itemIconData.type == ResourceType.Money
                            and v.itemIconData.itemId == MoneyType.SUMMON_HEROIC_SCROLL
                            and v.itemIconData.quantity == 1 then
                        shopIconView = v
                        break
                    end
                end
            end
            self.buyScrollCost = shopIconView.iconData.cost
            tutorial:ViewFocusCurrentTutorial(shopIconView.buttonBuyView.config.buttonBuy, 1.2, function()
                return shopIconView.config.transform.position
            end, nil, TutorialHandType.CLICK_BOTTOM)
        end)
    elseif step == TutorialStep.REFUND_BUY_SCROLL then
        tutorial:ViewFocusCurrentTutorial()
    elseif step == TutorialStep.BACK_BLACK_MARKET then
        local rewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, self.buyScrollCost.moneyType, self.buyScrollCost.value)
        SmartPoolUtils.ShowReward1Item(rewardInBound:GetIconData())
        rewardInBound:AddToInventory()

        local handType = nil
        if tutorial.currentTutorial.tutorialStepData.focus ~= TutorialFocus.TAP_TO_CLICK and
                tutorial.currentTutorial.tutorialStepData.focus ~= TutorialFocus.AUTO_NEXT then
            handType = TutorialHandType.MOVE_CLICK
        end
        tutorial:ViewFocusCurrentTutorial(self.config.buttonBack, 0.5, function()
            return self.config.buttonBack.transform:GetChild(0).position
        end, nil, handType)
    end
end

--- @return number
--- @param marketItemCount number
function UIMarketView:SetNumberPageByMarketItemsCount(marketItemCount)
    self.model.numberPage = math.ceil(marketItemCount / self.model.SLOT_PER_PAGE)
    self:SetUpButtonPage(self.model.numberPage)
end

--- @return void
function UIMarketView:NextPage()
    local nextPage = self.model.currentPage + 1
    if nextPage > self.model.numberPage then
        nextPage = 1
    end
    self.uiSelectPage:Select(nextPage)
end

--- @return void
function UIMarketView:PreviousPage()
    local nextPage = self.model.currentPage - 1
    if nextPage < 1 then
        nextPage = 1
    end
    self.uiSelectPage:Select(nextPage)
end

--- @param listItemCount number
function UIMarketView:GetRangeItem(listItemCount)
    local minIndex = (self.model.currentPage - 1) * self.model.SLOT_PER_PAGE + 1
    local maxIndex = math.min(listItemCount, minIndex + self.model.SLOT_PER_PAGE - 1)
    return minIndex, maxIndex
end

--- @param groupMarketItemRateConfig GroupMarketItemRateConfig
function UIMarketView:OnSelectShowInfo(groupMarketItemRateConfig)
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    --- @type {listRewardIconData : List}
    local data = {}
    --- @type List
    data.listRewardIconData = List()
    for i = 1, groupMarketItemRateConfig.listMarketItemRate:Count() do
        --- @type MarketItemRateConfig
        local marketItemRateConfig = groupMarketItemRateConfig.listMarketItemRate:Get(i)
        data.listRewardIconData:Add(marketItemRateConfig.rewardInBound:GetIconData())
    end
    PopupMgr.ShowPopup(UIPopupName.UIShowItemInRandomPool, data)
end

function UIMarketView:DisableCommon()
    self.config.textTimer.gameObject:SetActive(false)
    self.config.refreshButton.gameObject:SetActive(false)
    self.config.ugradingProcess.gameObject:SetActive(false)
    self.config.empty:SetActive(false)
    self.config.animUpgrade:SetActive(false)
    self:HideItemsTableView()
    self:RemoveUpdateTime()
end

--- @param bgName string
function UIMarketView:EnableBg(bgName)
    if self.bgMarket ~= nil then
        if self.bgMarket.bgName == bgName then
            return
        else
            self.bgMarket:SetActive(false)
        end
    end
    self.bgMarket = self.bgMarketDict:Get(bgName)
    if self.bgMarket == nil then
        local onBgLoaded = function(clone)
            self.bgMarket = BgMarket(clone.transform, self.config.transform, bgName)
            self.bgMarketDict:Add(bgName, self.bgMarket)
            self.bgMarket:OnShow()
        end
        PrefabLoadUtils.InstantiateAsync(bgName, onBgLoaded)
    else
        self.bgMarket:OnShow()
    end
end

function UIMarketView:DisablePage()
    self.uiSelectPage:SetPagesCount(0)
    self.config.buttonArrowLeft.gameObject:SetActive(false)
    self.config.buttonArrowRight.gameObject:SetActive(false)
end