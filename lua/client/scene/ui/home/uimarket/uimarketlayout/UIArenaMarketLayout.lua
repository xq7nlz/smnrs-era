--- @class UIArenaMarketLayout : UIMarketLayout
UIArenaMarketLayout = Class(UIArenaMarketLayout, UIMarketLayout)

--- @param view UIMarketView
--- @param marketType MarketType
--- @param tabAnchor UnityEngine_RectTransform
function UIArenaMarketLayout:Ctor(view, marketType, tabAnchor)
    UIMarketLayout.Ctor(self, view, marketType)
    self.playerDataMethod = PlayerDataMethod.ARENA_MARKET
    self.opCodeBuy = OpCode.ARENA_MARKET_BUY
    self.opCodeRefresh = OpCode.MARKET_REFRESH
    self.opCodeUpgrade = OpCode.ARENA_MARKET_UPGRADE
    self.upgradeMoneyType = MoneyType.ARENA_MARKET_UPGRADE_COIN
    --- @type ArenaMarketConfig
    self.marketConfig = ResourceMgr.GetArenaMarket()
    --- @type UnityEngine_UI_Text
    self.textTab = tabAnchor:Find("on/text"):GetComponent(ComponentName.UnityEngine_UI_Text)
end

function UIArenaMarketLayout:InitLocalization()
    UIMarketLayout.InitLocalization(self)
    self.textTab.text = LanguageUtils.LocalizeCommon("arena_shop")
end

function UIArenaMarketLayout:FireTracking()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.BLACK_MARKET, "arena")
end

function UIArenaMarketLayout:SetUpLayout()
    self.view:EnableBg("bg_black_market")
    self.config.buttonTabAnchor.gameObject:SetActive(true)
    self.view:SetUpMoneyBar(MoneyType.GOLD, MoneyType.ARENA_COIN)
    self.view.tab:HighlightTabByIndex(self.marketType)
end

--- @return boolean
function UIArenaMarketLayout:IsAvailableToRequest()
    local data = zg.playerData:GetMethod(self.playerDataMethod)
    return data == nil or data.marketItemList == nil
end

function UIArenaMarketLayout:RequestShopData()
    UIMarketLayout.RequestShopData(self)
    local onSuccess = function()
        self:OnLoadedShopData()
    end
    PlayerDataRequest.RequestAndCallback({ self.playerDataMethod }, onSuccess, SmartPoolUtils.LogicCodeNotification)
end

function UIArenaMarketLayout:OnLoadedShopData()
    self.modeShopDataInBound = zg.playerData:GetMethod(self.playerDataMethod)
    self.marketItemList = self.modeShopDataInBound.marketItemList
    self.marketConfig:LoadCsv(self.modeShopDataInBound.level)

    UIMarketLayout.OnLoadedShopData(self)
end

function UIArenaMarketLayout:UpdateTimeRefresh()
    self.config.textTimer.gameObject:SetActive(true)
    UIMarketLayout.UpdateTimeRefresh(self, function()
        --- @type EventTimeData
        local eventTime = zg.playerData:GetEvents():GetEvent(EventTimeType.ARENA):GetTime()
        self.timeRefresh = eventTime.endTime - zg.timeMgr:GetServerTime()
    end, function()
        local onSuccessUpdateEventTime = function()
            self:OnShow()
        end
        EventInBound.ValidateEventModel(onSuccessUpdateEventTime, true)
    end)
end

function UIArenaMarketLayout:ShowButtonRefresh()
    self.view:ShowRefreshPrice(self.marketConfig)
    UIMarketLayout.ShowButtonRefresh(self)
end

function UIArenaMarketLayout:ShowUpgradingBtn()
    UIMarketLayout.ShowUpgradingBtn(self)
    UIMarketLayout.ShowUpgradingProcess(self, LanguageUtils.LocalizeCommon("arena_shop"))
end

function UIArenaMarketLayout:CheckActive()
    --- @type EventMarketModel
    self.eventArenaModel = zg.playerData:GetEvents():GetEvent(EventTimeType.ARENA)
end

function UIArenaMarketLayout:OnShow()
    self:CheckActive()
    self:SetUpLayout()
    if self.eventArenaModel:IsOpening() then
        UIMarketLayout.OnShow(self)
    else
        self.view:DisablePage()
        self.config.textEmpty.text = LanguageUtils.LocalizeCommon("closed")
        self.config.empty:SetActive(true)
    end
end