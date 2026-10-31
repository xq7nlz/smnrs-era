require "lua.client.scene.ui.home.uiPopupPurchaseLevel.PurchaseLevelItem"
--- @class UIPopupPurchaseLevelView : UIBaseView
UIPopupPurchaseLevelView = Class(UIPopupPurchaseLevelView, UIBaseView)

--- @return void
--- @param model UIPopupRewardModel
function UIPopupPurchaseLevelView:Ctor(model, ctrl)
    --- @type UIPopupPurchaseLevelConfig
    self.config = nil
    ---@type Dictionary
    self.rewardDict = Dictionary()
    ---@type number
    self.updateTime = nil
    ---@type number
    self.endTime = nil
    ---@type Dictionary
    self.dictNumberBuy = Dictionary()
    ---@type Dictionary
    self.bundleLayoutDict = Dictionary()
    ---@type function
    self.onClosePopup = nil
    UIBaseView.Ctor(self, model, ctrl)
end

--- @return void
function UIPopupPurchaseLevelView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButton()
    self:InitBundleLayout()
    self:InitUpdateTime()
end

function UIPopupPurchaseLevelView:InitBundleLayout()
    --- @type List
    for i = 1, self.config.bundleAnchor.childCount do
        local layout = PurchaseLevelItem(self.config.bundleAnchor:GetChild(i - 1))
        self.bundleLayoutDict:Add(i, layout)
    end
end

--- @return void
function UIPopupPurchaseLevelView:InitButton()
    self.config.bgClose.onClick:AddListener(function()
        --self:OnClickBackOrClose()
    end)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

---@param productConfig ProductConfig
function UIPopupPurchaseLevelView:OnClickBuyBundleLevel(productConfig, onBuySuccess)
    if productConfig.priceType == IapPackPriceType.WATCH_ADS then
        self:WatchAds(productConfig, onBuySuccess)
    else
        self:RequestBuy(productConfig, onBuySuccess)
    end
end

---@param productConfig ProductConfig
function UIPopupPurchaseLevelView:RequestBuy(productConfig, onBuySuccess)
    BuyUtils.InitListener(function()
        if self.onBuySuccess then
            self.onBuySuccess()
        end
        if onBuySuccess then
            onBuySuccess()
        end
    end)
    RxMgr.purchaseProduct:Next(productConfig.productID)
end

---@param productConfig ProductConfig
function UIPopupPurchaseLevelView:WatchAds(productConfig, onBuySuccess)
    VideoRewardedUtils.SetType(1)
    VideoRewardedUtils.SetAction(function()
        self:RequestBuy(productConfig, onBuySuccess)
    end)
    IapDataInBound.Validate(function()
        if VideoRewardedUtils.AllowSkipVideo() then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "watch_video", 0)
            VideoRewardedUtils.RequestToServer()
        else
            VideoRewardedUtils.OpenRewarded(AdsPlacement.EVENT_BUY_LEVEL)
        end
    end)
end

--- @return void
function UIPopupPurchaseLevelView:InitItemLocalization(textTitle)
    self.config.textTitle.text = LanguageUtils.LocalizeCommon(textTitle)
end

--- @param data {onBuySuccess, onClosePopup, listProduct : List, dictNumberBuy : Dictionary, textTitle, bundleLocalize, endTime, numberBuy, remainWatchAds}
function UIPopupPurchaseLevelView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)
    self.onBuySuccess = data.onBuySuccess
    self.dictNumberBuy = data.dictNumberBuy
    self.endTime = data.endTime
    self.listProduct = data.listProduct
    self.remainWatchAds = data.remainWatchAds
    self:InitItemLocalization(data.textTitle)
    self:SetItemBundleData(data.listProduct, data.bundleLocalize, data.numberBuy)
    if self.endTime then
        self:StartRefreshTime()
    end
    self.onClosePopup = data.onClosePopup
end

function UIPopupPurchaseLevelView:SetItemBundleData(listProduct, bundleLocalize, numberBuy)
    --- @param v PurchaseLevelItem
    for k, v in pairs(self.bundleLayoutDict:GetItems()) do
        v:InitLocalization(bundleLocalize .. k)
        v:AddButtonListener()
        ---@type ProductConfig
        local productConfig = listProduct:Get(k)
        if productConfig then
            v:SetButtonText(productConfig, numberBuy, self.remainWatchAds)
            v:SetRewardAnchor(productConfig)
            v:AddButtonListener(function()
                if productConfig.priceType == IapPackPriceType.WATCH_ADS then
                    self:OnClickBuyBundleLevel(productConfig, function()
                        self.remainWatchAds = self.remainWatchAds - 1
                        v:SetButtonText(productConfig, numberBuy, self.remainWatchAds)
                    end)
                else
                    self:OnClickBuyBundleLevel(productConfig)
                end
            end)
        end
    end
end

function UIPopupPurchaseLevelView:ReturnPoolBundleItem()
    --- @param v PurchaseLevelItem
    for _, v in pairs(self.bundleLayoutDict:GetItems()) do
        v:ReturnPool()
    end
end

--- @return void
function UIPopupPurchaseLevelView:Hide()
    UIBaseView.Hide(self)
    self:ReturnPoolBundleItem()
    self:RemoveUpdateTime()
    if self.onClosePopup then
        self.onClosePopup()
    end
end

function UIPopupPurchaseLevelView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self:SetTextTimeRefresh()
        if self.timeRefresh < 0 then
            self:OnReadyHide()
        end
    end
end

function UIPopupPurchaseLevelView:SetTimeRefresh()
    self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIPopupPurchaseLevelView:StartRefreshTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIPopupPurchaseLevelView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIPopupPurchaseLevelView:SetTextTimeRefresh()
    self.config.textTimer.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
            UIUtils.SetColorString(UIUtils.green_dark, TimeUtils.GetDeltaTime(self.timeRefresh)))
end
