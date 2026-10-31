--- @class UIEventMarketLayout : UIMarketLayout
UIEventMarketLayout = Class(UIEventMarketLayout, UIMarketLayout)

--- @param view UIMarketView
--- @param marketType MarketType
--- @param tabAnchor UnityEngine_RectTransform
function UIEventMarketLayout:Ctor(view, marketType, tabAnchor)
    UIMarketLayout.Ctor(self, view, marketType)
    self.opCodeBuy = OpCode.EVENT_MARKET_BUY
    --- @type EventMarketModel
    self.eventMarketModel = nil
    --- @type EventMarketConfig
    self.marketConfig = nil
    --- @type UnityEngine_UI_Text
    self.textTab = tabAnchor:Find("on/text"):GetComponent(ComponentName.UnityEngine_UI_Text)
end

function UIEventMarketLayout:InitLocalization()
    UIMarketLayout.InitLocalization(self)
    self.textTab.text = LanguageUtils.LocalizeCommon("soul_shop")
    self.formatTimer = string.format("%s %%s", LanguageUtils.LocalizeCommon("will_end_in"))
end

function UIEventMarketLayout:FireTracking()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.BLACK_MARKET, "event")
end

function UIEventMarketLayout:SetUpLayout()
    self.view:EnableBg("bg_black_market")
    self.config.buttonTabAnchor.gameObject:SetActive(true)
    self.view:SetUpMoneyBar(MoneyType.TIER_1_SOUL, MoneyType.TIER_2_SOUL, MoneyType.TIER_3_SOUL)
    self.view.tab:HighlightTabByIndex(self.marketType)
end

function UIEventMarketLayout:OnShow()
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
function UIEventMarketLayout:IsAvailableToRequest()
    --- @type EventMarketModel
    self.eventMarketModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MARKET)
    return self.eventMarketModel == nil or self.eventMarketModel.modeShopDataInBound.marketItemList == nil
end

function UIEventMarketLayout:RequestShopData()
    UIMarketLayout.RequestShopData(self)
    --- @type EventMarketModel
    self.eventMarketModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MARKET)
    self.eventMarketModel:RequestEventData(function()
        self:OnLoadedShopData()
    end)
end

function UIEventMarketLayout:OnLoadedShopData()
    self.eventMarketModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MARKET)
    self.modeShopDataInBound = self.eventMarketModel.modeShopDataInBound
    self.marketItemList = self.modeShopDataInBound.marketItemList
    UIMarketLayout.OnLoadedShopData(self)
end

function UIEventMarketLayout:UpdateTimeRefresh()
    self.config.textTimer.gameObject:SetActive(true)
    UIMarketLayout.UpdateTimeRefresh(self, function()
        --- @type EventTimeData
        local eventTime = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MARKET):GetTime()
        self.timeRefresh = eventTime.endTime - zg.timeMgr:GetServerTime()
    end, function()
        local onSuccessUpdateEventTime = function()
            self:OnShow()
        end
        EventInBound.ValidateEventModel(onSuccessUpdateEventTime, true)
    end)
end

function UIEventMarketLayout:ShowButtonRefresh()
end

function UIEventMarketLayout:ShowUpgradingBtn()

end

function UIEventMarketLayout:CheckActive()
    --- @type EventMarketModel
    self.eventMarketModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MARKET)
    if self.eventMarketModel ~= nil and self.eventMarketModel:IsOpening() then
        --- @type EventMarketConfig
        self.marketConfig = self.eventMarketModel:GetConfig()
    else
        self.marketConfig = nil
    end
end