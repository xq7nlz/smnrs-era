--- @class UISpecialOfferMidAutumnItemView
UISpecialOfferMidAutumnItemView = Class(UISpecialOfferMidAutumnItemView)

--- @param transform UnityEngine_Transform
function UISpecialOfferMidAutumnItemView:Ctor(view, transform)
    --- @type UIEventMidAutumnView
    self.view = view
    --- @type UISpecialOfferMidAutumnItemConfig
    self.config = UIBaseConfig(transform)
    --- @type number
    self.packId = nil
    --- @type number
    self.dataId = nil
    --- @type string
    self.packKey = nil
    --- @type OpCode
    self.opCode = OpCode.EVENT_MID_AUTUMN_PURCHASE
    --- @type ItemsTableView
    self.itemsTable = nil
    --- @type IapDataInBound
    self.iapDataInBound = nil
    --- @type EventMidAutumnModel
    self.eventMidAutumnModel = nil

    self:InitUI(transform)
    self:InitButtonListener()
    self:InitItemTableView()
end

function UISpecialOfferMidAutumnItemView:InitUI(transform)
    transform:GetChild(0):GetChild(0):GetComponent(ComponentName.UnityEngine_UI_ScrollRect).enabled = false
    transform:GetChild(0):GetChild(0):GetComponent(typeof(CS.SoftMasking.SoftMask)).enabled = false
end

function UISpecialOfferMidAutumnItemView:InitButtonListener()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
end

function UISpecialOfferMidAutumnItemView:InitItemTableView()
    self.itemsTable = ItemsTableView(self.config.resAnchor)
end

function UISpecialOfferMidAutumnItemView:OnShow(packId, dataId)
    self.dataId = dataId
    self.packId = packId
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId, dataId)
    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    self.eventMidAutumnModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MID_AUTUMN)
    self.config.tittle.text = LanguageUtils.LocalizeCommon(string.format("mid_autumn_offer_%d", self.packId))

    self:ShowPack()
    --self:SetPrice()
end

function UISpecialOfferMidAutumnItemView:ShowPack()
    LanguageUtils.CheckInitLocalize(self, UISpecialOfferMidAutumnItemView.InitLocalization)
    ---- @type EventMidAutumnProduct
    self.data = ResourceMgr.GetPurchaseConfig():GetMidAutumn():GetPack(self.dataId):GetPackBase(self.packId)
    local vipText, rewardList = self.data:GetReward()
    self:SetInstantReward(rewardList)
    self:SetVipText(vipText)

    self.numberBought = self.eventMidAutumnModel:GetNumberBuy(EventActionType.MID_AUTUMN_SPECIAL_OFFER_PURCHASE, self.packId)
    local left = self.data.stock
    left = self.data.stock - self.numberBought
    self:ShowTextBuy(left, self.data.stock)
    self:SetPrice()
    self.config.imageAds.gameObject:SetActive(false)
    self.priceType = tonumber(self.data.priceType)
    self.numberWatchAds = self.data.numberWatchAds
    self.stock = self.data.stock
    if self.priceType == IapPackPriceType.FREE then
        self.data.isFree = true
        if self.stock > self.numberBought and self.numberWatchAds and self.numberBought >= self.stock - self.numberWatchAds then
            self.config.imageAds.gameObject:SetActive(true)
            self.config.textPrice.text = LanguageUtils.LocalizeCommon("watch")
        elseif self.stock > self.numberBought then
            self.config.textPrice.text = LanguageUtils.LocalizeCommon("free")
        else
            self.config.imageAds.gameObject:SetActive(true)
            self.config.textPrice.text = LanguageUtils.LocalizeCommon("watch")
        end
    else
        self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    end
end

function UISpecialOfferMidAutumnItemView:SetPrice()
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
end

function UISpecialOfferMidAutumnItemView:SetInstantReward(rewardList)
    self.itemsTable:SetData(RewardInBound.GetItemIconDataList(rewardList), UIPoolType.ItemInfoView)
end

function UISpecialOfferMidAutumnItemView:SetVipText(vipText)
    self.config.vipText.text = "+" .. tostring(vipText)
end

function UISpecialOfferMidAutumnItemView:Hide()
    self.itemsTable:Hide()
end

function UISpecialOfferMidAutumnItemView:OnClickBuy()
    if self:CanBuy() then
        local packKey = self.packKey
        if self.data ~= nil then
            packKey = ClientConfigUtils.GetPurchaseKey(self.data.opCode, self.data.id, self.data.dataId)
        end
        if self.priceType == IapPackPriceType.WATCH_ADS or (self.numberWatchAds and self.priceType == IapPackPriceType.FREE and self.numberBought >= self.stock - self.numberWatchAds) then
            self:WatchAds()
        else
            BuyUtils.InitListener(function()
                PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, function()
                    self.eventMidAutumnModel:AddNumberBuy(EventActionType.MID_AUTUMN_SPECIAL_OFFER_PURCHASE, self.packId, 1)
                    self:ShowPack()
                end)
                self.view:CheckAllNotificationTab()
            end)
            RxMgr.purchaseProduct:Next(packKey)
        end
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function UISpecialOfferMidAutumnItemView:WatchAds()
    local packKey = self.packKey
    if self.data ~= nil then
        packKey = ClientConfigUtils.GetPurchaseKey(self.data.opCode, self.data.id, self.data.dataId)
    end
    VideoRewardedUtils.SetType(1)
    VideoRewardedUtils.SetAction(function()
        BuyUtils.InitListener(function()
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, function()
                self.eventMidAutumnModel:AddNumberBuy(EventActionType.MID_AUTUMN_SPECIAL_OFFER_PURCHASE, self.packId, 1)
                self:ShowPack()
            end)
            self.view:CheckAllNotificationTab()
        end)
        RxMgr.purchaseProduct:Next(packKey)
    end)
    IapDataInBound.Validate(function()
        if VideoRewardedUtils.AllowSkipVideo() then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "watch_video", 0)
            VideoRewardedUtils.RequestToServer()
        else
            VideoRewardedUtils.OpenRewarded(AdsPlacement.EVENT_MID_AUTUMN_BUNDLE)
        end
    end)
end

--- @param left number
--- @param max number
function UISpecialOfferMidAutumnItemView:ShowTextBuy(left, max)
    if left == nil or max == nil then
        self.config.localizeBuy.text = LanguageUtils.LocalizeCommon("buy")
    else
        local color = UIUtils.color2
        if left == 0 then
            color = UIUtils.red_dark
        end
        self.config.localizeBuy.text = string.format("%s %s",
                LanguageUtils.LocalizeCommon("buy"),
                UIUtils.SetColorString(color, string.format("(%s/%s)", left, max)))
    end
end

function UISpecialOfferMidAutumnItemView:CanBuy()
    --local self.numberBought = self.eventMidAutumnModel:GetNumberBuy(EventActionType.MID_AUTUMN_SPECIAL_OFFER_PURCHASE, self.packId)
    return (self.data.stock - self.numberBought) > 0
end




