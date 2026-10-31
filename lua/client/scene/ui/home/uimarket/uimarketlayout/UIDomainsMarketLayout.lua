--- @class UIDomainsMarketLayout : UIMarketLayout
UIDomainsMarketLayout = Class(UIDomainsMarketLayout, UIMarketLayout)

--- @param view UIMarketView
--- @param marketType MarketType
--- @param tabAnchor UnityEngine_RectTransform
function UIDomainsMarketLayout:Ctor(view, marketType, tabAnchor)
    UIMarketLayout.Ctor(self, view, marketType)
    self.playerDataMethod = PlayerDataMethod.MARKET
    self.opCodeBuy = OpCode.MARKET_BUY
    self.opCodeRefresh = OpCode.MARKET_REFRESH
    self.opCodeUpgrade = OpCode.MARKET_UPGRADE
    self.upgradeMoneyType = MoneyType.BLACK_MARKET_UPGRADE_COIN
    --- @type BlackMarketConfig
    self.marketConfig = ResourceMgr.GetBlackMarket()
    --- @type UnityEngine_UI_Text
    self.textTab = tabAnchor:Find("on/text"):GetComponent(ComponentName.UnityEngine_UI_Text)
end

function UIDomainsMarketLayout:InitLocalization()
    UIMarketLayout.InitLocalization(self)
    self.textTab.text = LanguageUtils.LocalizeCommon("domains_shop")
end

function UIDomainsMarketLayout:FireTracking()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.BLACK_MARKET, "main")
end

function UIDomainsMarketLayout:SetUpLayout()
    self.view:EnableBg("bg_black_market")
    self.config.buttonTabAnchor.gameObject:SetActive(true)
    self.view:SetUpMoneyBar(MoneyType.GOLD, MoneyType.GEM)
    self.view.tab:HighlightTabByIndex(self.marketType)
end

--- @return boolean
function UIDomainsMarketLayout:IsAvailableToRequest()
    local data = zg.playerData:GetMethod(self.playerDataMethod)
    return data == nil or data.marketItemList == nil
end

function UIDomainsMarketLayout:RequestShopData()
    UIMarketLayout.RequestShopData(self)
    local onSuccess = function()
        self:OnLoadedShopData()
    end
    PlayerDataRequest.RequestAndCallback({ self.playerDataMethod }, onSuccess, SmartPoolUtils.LogicCodeNotification)
end

function UIDomainsMarketLayout:OnLoadedShopData()
    self.modeShopDataInBound = zg.playerData:GetMethod(self.playerDataMethod)
    self.marketItemList = self.modeShopDataInBound.marketItemList
    self.marketConfig:LoadCsv(self.modeShopDataInBound.level)
    UIMarketLayout.OnLoadedShopData(self)
end

function UIDomainsMarketLayout:UpdateTimeRefresh()
    self.config.textTimer.gameObject:SetActive(true)
    UIMarketLayout.UpdateTimeRefresh(self, function()
        self.timeRefresh = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay - zg.timeMgr:GetServerTime()
    end)
end

function UIDomainsMarketLayout:ShowButtonRefresh()
    self.view:ShowRefreshPrice(self.marketConfig)
    UIMarketLayout.ShowButtonRefresh(self)
end

function UIDomainsMarketLayout:ShowUpgradingBtn()
    UIMarketLayout.ShowUpgradingBtn(self)
    UIMarketLayout.ShowUpgradingProcess(self, LanguageUtils.LocalizeFeature(FeatureType.BLACK_MARKET))
end