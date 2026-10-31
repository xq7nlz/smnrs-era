--- @class UISpecialOfferChristmasItemView
UISpecialOfferChristmasItemView = Class(UISpecialOfferChristmasItemView)

local BUY_SUCCESS = 1
local LIMIT_BUY = 0
local BUY_FAIL = 2

--- @param transform UnityEngine_Transform
function UISpecialOfferChristmasItemView:Ctor(view, transform)
    --- @type UIEventChristmasView
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
    self.opCode = OpCode.EVENT_CHRISTMAS_PURCHASE
    --- @type ItemsTableView
    self.itemsTable = nil
    --- @type IapDataInBound
    self.iapDataInBound = nil
    --- @type EventChristmasModel
    self.eventModel = nil

    self:InitUI(transform)
    self:InitButtonListener()
    self:InitItemTableView()
end

function UISpecialOfferChristmasItemView:InitUI(transform)
    transform:GetChild(0):GetChild(0):GetComponent(ComponentName.UnityEngine_UI_ScrollRect).enabled = false
    transform:GetChild(0):GetChild(0):GetComponent(typeof(CS.SoftMasking.SoftMask)).enabled = false
end

function UISpecialOfferChristmasItemView:InitButtonListener()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
end

function UISpecialOfferChristmasItemView:InitItemTableView()
    self.itemsTable = ItemsTableView(self.config.resAnchor)
end

function UISpecialOfferChristmasItemView:OnShow(packId, dataId)
    self.dataId = dataId
    self.packId = packId
    self.data = ResourceMgr.GetPurchaseConfig():GetChristmas():GetPack(self.dataId):GetPackBase(self.packId)
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId, dataId)
    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_CHRISTMAS)
    self.config.tittle.text = LanguageUtils.LocalizeCommon(string.format("christmas_offer_%d", self.packId))

    self:ShowPack()
    self:SetPrice()
end

function UISpecialOfferChristmasItemView:ShowPack()
    LanguageUtils.CheckInitLocalize(self, UISpecialOfferChristmasItemView.InitLocalization)
    ---- @type EventHalloweenProduct
    local vipText, rewardList = self.data:GetReward()
    self:SetInstantReward(rewardList)
    self:SetVipText(vipText)

    local numberBought = self.eventModel:GetNumberBuy(EventActionType.CHRISTMAS_SPECIAL_OFFER_PURCHASE, self.packId)
    local left = self.data.stock
    left = self.data.stock - numberBought
    self:ShowTextBuy(left, self.data.stock)
end

function UISpecialOfferChristmasItemView:SetPrice()
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
end

function UISpecialOfferChristmasItemView:SetInstantReward(rewardList)
    self.itemsTable:SetData(RewardInBound.GetItemIconDataList(rewardList), UIPoolType.ItemInfoView)
end

function UISpecialOfferChristmasItemView:SetVipText(vipText)
    self.config.vipText.text = "+" .. tostring(vipText)
end

function UISpecialOfferChristmasItemView:Hide()
    self.itemsTable:Hide()
end

function UISpecialOfferChristmasItemView:OnClickBuy()
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
                    self.eventModel:AddNumberBuy(EventActionType.CHRISTMAS_SPECIAL_OFFER_PURCHASE, self.packId, 1)
                    self:ShowPack()
                end)
                self.view:CheckAllNotificationTab()
                TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_CHRISTMAS, self.data.androidPackageName, BUY_SUCCESS)
            end, function()
                TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_CHRISTMAS, self.data.androidPackageName, BUY_FAIL)
            end)
            RxMgr.purchaseProduct:Next(packKey)
        end
    else
        TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_CHRISTMAS, self.data.androidPackageName, LIMIT_BUY)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

--- @param left number
--- @param max number
function UISpecialOfferChristmasItemView:ShowTextBuy(left, max)
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

function UISpecialOfferChristmasItemView:CanBuy()
    local numberBought = self.eventModel:GetNumberBuy(EventActionType.CHRISTMAS_SPECIAL_OFFER_PURCHASE, self.packId)
    return (self.data.stock - numberBought) > 0
end




