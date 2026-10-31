--- @class UIEventMarketNewVersionLayout : UIMarketLayout
UIEventMarketNewVersionLayout = Class(UIEventMarketNewVersionLayout, UIMarketLayout)

--- @param view UIMarketView
--- @param marketType MarketType
--- @param tabAnchor UnityEngine_RectTransform
function UIEventMarketNewVersionLayout:Ctor(view, marketType, tabAnchor)
    UIMarketLayout.Ctor(self, view, marketType)
    self.opCodeBuy = OpCode.EVENT_SOUL_SHOP_BUY
    self.opCodeRefresh = OpCode.EVENT_SOUL_SHOP_REFRESH
    self.playerDataMethod = true
    --- @type EventMarketNewVersionModel
    self.eventMarketModel = nil
    --- @type EventMarketConfig
    self.marketConfig = nil
    --- @type UnityEngine_UI_Text
    self.textTab = tabAnchor:Find("on/text"):GetComponent(ComponentName.UnityEngine_UI_Text)
    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_SOUL_SHOP
    self.modeShopDataInBound = {}
    self.modeShopDataInBound.level = 1
end

function UIEventMarketNewVersionLayout:InitLocalization()
    UIMarketLayout.InitLocalization(self)
    self.textTab.text = LanguageUtils.LocalizeCommon("soul_shop")
    self.formatTimer = string.format("%s %%s", LanguageUtils.LocalizeCommon("will_end_in"))
end

function UIEventMarketNewVersionLayout:FireTracking()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.BLACK_MARKET, "event")
end

function UIEventMarketNewVersionLayout:SetUpLayout()
    self.view:EnableBg("bg_black_market")
    self.config.buttonTabAnchor.gameObject:SetActive(true)
    self.view:SetUpMoneyBar(MoneyType.TIER_1_SOUL, MoneyType.TIER_2_SOUL, MoneyType.TIER_3_SOUL)
    self.view.tab:HighlightTabByIndex(self.marketType)
end

function UIEventMarketNewVersionLayout:OnShow()
    self:CheckActive()
    if self.marketConfig ~= nil then
        UIMarketLayout.OnShow(self)
    else
        self:SetUpLayout()
        self.view:DisablePage()
        self.config.textEmpty.text = LanguageUtils.LocalizeCommon("closed")
        self.config.empty:SetActive(true)
    end
end

--- @return boolean
function UIEventMarketNewVersionLayout:IsAvailableToRequest()
    self.eventMarketModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    return self.eventMarketModel == nil
end

function UIEventMarketNewVersionLayout:RequestShopData()
    UIMarketLayout.RequestShopData(self)
    self.eventMarketModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.eventMarketModel:RequestEventData(function()
        self:OnLoadedShopData()
    end)
end

function UIEventMarketNewVersionLayout:OnLoadedShopData(dataId)
    ---@type List
    local listItem
    self.eventMarketModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if dataId then
        listItem = self.eventMarketModel:GetMarketItemListByDataId(dataId)
    else
        listItem = self.eventMarketModel.marketItemList
    end
    self.modeShopDataInBound.marketItemList = listItem
    self.marketItemList = listItem
    UIMarketLayout.OnLoadedShopData(self)
end

function UIEventMarketNewVersionLayout:UpdateTimeRefresh()
    self.config.textTimer.gameObject:SetActive(true)
    UIMarketLayout.UpdateTimeRefresh(self, function()
        --- @type EventTimeData
        local eventTime = zg.playerData:GetEvents():GetEvent(self.eventTimeType):GetTime()
        self.timeRefresh = eventTime.endTime - zg.timeMgr:GetServerTime()
    end, function()
        local onSuccessUpdateEventTime = function()
            self:OnShow()
        end
        EventInBound.ValidateEventModel(onSuccessUpdateEventTime, true)
    end)
end

function UIEventMarketNewVersionLayout:ShowButtonRefresh()
    self.config.refreshButton.gameObject:SetActive(false)
    if self.marketConfig and self.eventMarketModel then
        self.view:ShowRefreshPrice(self.marketConfig)
        self.config.refreshButton.gameObject:SetActive(self.eventMarketModel:IsOpening() and self.eventMarketModel:CanRefreshDataId())
    end
end

function UIEventMarketNewVersionLayout:ShowUpgradingBtn()
end

function UIEventMarketNewVersionLayout:OnSuccessRefreshMarket(result)
    local dataId
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        dataId = buffer:GetInt()
    end
    local onSuccess = function()
        self.eventMarketModel:ResetNumberBuyMarketItem()
        self:OnLoadedShopData(dataId)
        InventoryUtils.Sub(ResourceType.Money, self.marketConfig.refreshMoneyType, self.marketConfig.refreshPrice)
        self.view:ShowRefreshPriceText(self.marketConfig)
    end
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
    end
    NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
end

function UIEventMarketNewVersionLayout:CheckActive()
    self.eventMarketModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventMarketModel ~= nil and self.eventMarketModel:IsOpening() then
        --- @type EventMarketConfig
        self.marketConfig = self.eventMarketModel:GetConfig()
        ---@type {moneyType, moneyValue}
        local refreshConfig = self.eventMarketModel.config:GetRefreshMoneyData()
        self.marketConfig.refreshMoneyType = refreshConfig.moneyType
        self.marketConfig.refreshPrice = refreshConfig.moneyValue
    else
        self.marketConfig = nil
    end
end

--- @param iconView ModeShopIconView
--- @param onBuySuccess function
function UIEventMarketNewVersionLayout:RequestBuyItem(iconView, onBuySuccess)
    UIMarketLayout.RequestBuyItem(self, iconView, function()
        self.eventMarketModel:AddNumberBuyMarketItem(iconView.iconData.id)
        InventoryUtils.Sub(ResourceType.Money, iconView.iconData.cost.moneyType, iconView.iconData.cost.value)
        self.eventMarketModel:AddNumberBoughtMarketItem(iconView.iconData.id)
        self.eventMarketModel:ValidateMarketItemList()
        if onBuySuccess then
            onBuySuccess()
        end
    end)
end