--- @class UISpecialOfferValentine2024ItemView
UISpecialOfferValentine2024ItemView = Class(UISpecialOfferValentine2024ItemView)

local BUY_SUCCESS = 1
local LIMIT_BUY = 0
local BUY_FAIL = 2

--- @param transform UnityEngine_Transform
function UISpecialOfferValentine2024ItemView:Ctor(view, transform)
    --- @type UIEventValentine2024View
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
    self.opCode = nil
    --- @type ItemsTableView
    self.itemsTable = nil
    --- @type IapDataInBound
    self.iapDataInBound = nil
    --- @type EventValentine2024Model
    self.eventModel = nil

    self:InitButtonListener()
    self:InitItemTableView()
end

function UISpecialOfferValentine2024ItemView:InitButtonListener()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
end

function UISpecialOfferValentine2024ItemView:InitItemTableView()
    self.itemsTable = ItemsTableView(self.config.resAnchor)
end

function UISpecialOfferValentine2024ItemView:OnShow(packId, dataId)
    self.dataId = dataId
    self.packId = packId
    self.data = ResourceMgr.GetPurchaseConfig():GetEventValentine2024BundleStore():GetPack(self.dataId):GetPackBase(self.packId)
    self.opCode = self.data.opCode
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId, dataId)
    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_VALENTINE_2024)
    self.config.tittle.text = LanguageUtils.LocalizeCommon(string.format("valentine_2024_purchase_%d", self.packId))

    self:ShowPack()
    self:SetPrice()
end

function UISpecialOfferValentine2024ItemView:ShowPack()
    LanguageUtils.CheckInitLocalize(self, UISpecialOfferValentine2024ItemView.InitLocalization)
    ---- @type EventValentine2024Product
    local vipText, rewardList = self.data:GetReward()
    self:SetInstantReward(rewardList)
    self:SetVipText(vipText)

    local numberBought = self.eventModel:GetNumberBuy(EventActionType.VALENTINE_2024_BUNDLE_PURCHASE, self.packId)
    local left = self.data.stock
    left = self.data.stock - numberBought
    self:ShowTextBuy(left, self.data.stock)
end

function UISpecialOfferValentine2024ItemView:SetPrice()
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
  --  XDebug.Log("pack key: "..tostring(self.packKey))
end

function UISpecialOfferValentine2024ItemView:SetInstantReward(rewardList)
    self.itemsTable:SetData(RewardInBound.GetItemIconDataList(rewardList), UIPoolType.ItemInfoView)
end

function UISpecialOfferValentine2024ItemView:SetVipText(vipText)
    self.config.vipText.text = "+" .. tostring(vipText)
end

function UISpecialOfferValentine2024ItemView:Hide()
    self.itemsTable:Hide()
end

function UISpecialOfferValentine2024ItemView:OnClickBuy()
    if self:CanBuy() then
        local data = ResourceMgr.GetPurchaseConfig():GetEventValentine2024BundleStore():GetPack(self.dataId):GetPackBase(self.packId)
        local packKey = self.packKey
        if data ~= nil then
            packKey = ClientConfigUtils.GetPurchaseKey(data.opCode, data.id, data.dataId)
        end
        BuyUtils.InitListener(function()
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, function()
                self.eventModel:AddNumberBuy(EventActionType.VALENTINE_2024_BUNDLE_PURCHASE, self.packId, 1)
                self:ShowPack()
            end)
            self.view:CheckAllNotificationTab()
            TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_VALENTINE_2024, self.data.androidPackageName, BUY_SUCCESS)
        end, function()
            TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_VALENTINE_2024, self.data.androidPackageName, BUY_FAIL)
        end)
        RxMgr.purchaseProduct:Next(packKey)
    else
        TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_VALENTINE_2024, self.data.androidPackageName, LIMIT_BUY)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

--- @param left number
--- @param max number
function UISpecialOfferValentine2024ItemView:ShowTextBuy(left, max)
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

function UISpecialOfferValentine2024ItemView:CanBuy()
    local numberBought = self.eventModel:GetNumberBuy(EventActionType.VALENTINE_2024_BUNDLE_PURCHASE, self.packId)
    return (self.data.stock - numberBought) > 0
end
