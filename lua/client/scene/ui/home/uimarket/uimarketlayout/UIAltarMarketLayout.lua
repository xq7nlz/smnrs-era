--- @class UIAltarMarketLayout : UIMarketLayout
UIAltarMarketLayout = Class(UIAltarMarketLayout, UIMarketLayout)

--- @param view UIMarketView
--- @param marketType MarketType
--- @param tabAnchor UnityEngine_RectTransform
function UIAltarMarketLayout:Ctor(view, marketType, tabAnchor)
    UIMarketLayout.Ctor(self, view, marketType)
    self.playerDataMethod = PlayerDataMethod.ALTAR_MARKET
    self.opCodeBuy = OpCode.ALTAR_MARKET_BUY
    self.opCodeRefresh = OpCode.ALTAR_MARKET_REFRESH
    --- @type UnityEngine_UI_Text
    self.textTab = tabAnchor:Find("on/text"):GetComponent(ComponentName.UnityEngine_UI_Text)
end

function UIAltarMarketLayout:InitLocalization()
    self.textTab.text = LanguageUtils.LocalizeCommon("altar_shop")
end

function UIAltarMarketLayout:FireTracking()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.BLACK_MARKET, "altar")
end

function UIAltarMarketLayout:SetUpLayout()
    self.view:EnableBg("bg_black_market")
    self.config.buttonTabAnchor.gameObject:SetActive(true)
    self.view:SetUpMoneyBar(MoneyType.HERO_SHARD)
    self.view.tab:HighlightTabByIndex(self.marketType)
end

--- @return boolean
function UIAltarMarketLayout:IsAvailableToRequest()
    local data = zg.playerData:GetMethod(self.playerDataMethod)
    return data == nil or data.marketItemList == nil
end

function UIAltarMarketLayout:RequestShopData()
    UIMarketLayout.RequestShopData(self)
    local onSuccess = function()
        self:OnLoadedShopData()
    end
    PlayerDataRequest.RequestAndCallback({ self.playerDataMethod }, onSuccess, SmartPoolUtils.LogicCodeNotification)
end

function UIAltarMarketLayout:OnLoadedShopData()
    self.modeShopDataInBound = zg.playerData:GetMethod(self.playerDataMethod)
    self.marketItemList = self.modeShopDataInBound.marketItemList
    --- @type AltarMarketConfig
    self.marketConfig = ResourceMgr.GetAltarMarketConfig()
    UIMarketLayout.OnLoadedShopData(self)
end

function UIAltarMarketLayout:ShowButtonRefresh()
    self.view:ShowRefreshPrice(self.marketConfig)
    UIMarketLayout.ShowButtonRefresh(self)
end

function UIAltarMarketLayout:UpdateTimeRefresh()
    self.config.textTimer.gameObject:SetActive(false)
end