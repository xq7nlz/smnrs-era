--- @class UIBlackMarketLayout : UIMarketLayout
UIBlackMarketLayout = Class(UIBlackMarketLayout, UIMarketLayout)

--- @param view UIMarketView
--- @param marketType MarketType
--- @param tabAnchor UnityEngine_RectTransform
function UIBlackMarketLayout:Ctor(view, marketType, tabAnchor)
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

function UIBlackMarketLayout:InitLocalization()
    UIMarketLayout.InitLocalization(self)
    self.textTab.text = LanguageUtils.LocalizeFeature(FeatureType.BLACK_MARKET)
end

function UIBlackMarketLayout:FireTracking()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.BLACK_MARKET, "main")
end

function UIBlackMarketLayout:SetUpLayout()
    if UIBaseView.IsActiveTutorial()
            and self.view.tutorial.currentStep == TutorialBlackMarket.stepId then
        self.opCodeBuy = OpCode.TUTORIAL_MARKET_BUY
    else
        self.opCodeBuy = OpCode.MARKET_BUY
    end
    self.view:EnableBg("bg_black_market")
    self.config.buttonTabAnchor.gameObject:SetActive(true)
    self.view:SetUpMoneyBar(MoneyType.GOLD, MoneyType.GEM, MoneyType.TIER_1_SOUL, MoneyType.TIER_2_SOUL)
    self.view.tab:HighlightTabByIndex(self.marketType)
end

--- @return boolean
function UIBlackMarketLayout:IsAvailableToRequest()
    local data = zg.playerData:GetMethod(self.playerDataMethod)
    return data == nil or data.marketItemList == nil
end

function UIBlackMarketLayout:RequestShopData()
    UIMarketLayout.RequestShopData(self)
    local onSuccess = function()
        self:OnLoadedShopData()
    end
    PlayerDataRequest.RequestAndCallback({ self.playerDataMethod }, onSuccess, SmartPoolUtils.LogicCodeNotification)
end

function UIBlackMarketLayout:OnLoadedShopData()
    self.modeShopDataInBound = zg.playerData:GetMethod(self.playerDataMethod)
    self.marketItemList = self.modeShopDataInBound.marketItemList
    self.marketConfig:LoadCsv(self.modeShopDataInBound.level)
    UIMarketLayout.OnLoadedShopData(self)
end

function UIBlackMarketLayout:UpdateTimeRefresh()
    self.config.textTimer.gameObject:SetActive(true)
    UIMarketLayout.UpdateTimeRefresh(self, function()
        self.timeRefresh = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay - zg.timeMgr:GetServerTime()
    end)
end

function UIBlackMarketLayout:ShowButtonRefresh()
    self.view:ShowRefreshPrice(self.marketConfig)
    UIMarketLayout.ShowButtonRefresh(self)
end

function UIBlackMarketLayout:ShowUpgradingBtn()
    UIMarketLayout.ShowUpgradingBtn(self)
    UIMarketLayout.ShowUpgradingProcess(self, LanguageUtils.LocalizeFeature(FeatureType.BLACK_MARKET))
end