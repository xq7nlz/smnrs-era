--- @class UIEventBigBundleItem
UIEventBigBundleItem = Class(UIEventBigBundleItem)

--- @param transform UnityEngine_Transform
function UIEventBigBundleItem:Ctor(transform)
    --- @type EventBigBundleItemConfig
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
    --- @type EventLunarNewYearModel
    self.eventPopupModel = nil
    --- @type PurchaseStore
    self.purchaseStore = nil

    self:InitButtonListener()
    self:InitItemTableView()
end

function UIEventBigBundleItem:InitButtonListener()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
end

function UIEventBigBundleItem:InitItemTableView()
    self.itemsTable = ItemsTableView(self.config.resAnchor)
end

function UIEventBigBundleItem:SetLocalizeFunction(func)
    self.localizeFunc = func
end

--- @param purchaseStore PurchaseStore
--- @param eventActionType number
function UIEventBigBundleItem:OnShow(purchaseStore, eventTimeType, eventActionType, packId, dataId)
    self.purchaseStore = purchaseStore
    self.eventPopupModel = zg.playerData:GetEvents():GetEvent(eventTimeType)
    self.eventActionType = eventActionType
    self.dataId = dataId
    self.packId = packId

    self.data = purchaseStore:GetPack(self.dataId):GetPackBase(self.packId)
    self.opCode = self.data.opCode
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId, dataId)

    self:ShowPack()

    self:SetPrice()
end

function UIEventBigBundleItem:InitLocalization()
    if self.localizeFunc then
        self.config.tittle.text = self.localizeFunc()
    end
end

function UIEventBigBundleItem:ShowPack()
    LanguageUtils.CheckInitLocalize(self, UIEventBigBundleItem.InitLocalization)
    ---- @type EventXmasProduct
    local vipText, rewardList = self.data:GetReward()
    self:SetInstantReward(rewardList)

    self:SetVipText(vipText)

    local numberBought = self.eventPopupModel:GetNumberBuy(self.eventActionType, self.packId)
    local left = self.data.stock
    left = self.data.stock - numberBought
    self:ShowTextBuy(left, self.data.stock)
end

function UIEventBigBundleItem:SetPrice()
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
end

function UIEventBigBundleItem:SetInstantReward(rewardList)
    self.itemsTable:SetData(RewardInBound.GetItemIconDataList(rewardList), UIPoolType.ItemInfoView)
end

function UIEventBigBundleItem:SetVipText(vipText)
    self.config.vipPointView:SetActive(vipText ~= nil)
    if vipText then
        self.config.vipText.text = "+" .. tostring(vipText)
    end
end

function UIEventBigBundleItem:Hide()
    self.itemsTable:Hide()
end

function UIEventBigBundleItem:OnClickBuy()
    if self:CanBuy() then
        BuyUtils.InitListener(function()
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, function()
                self.eventPopupModel:AddNumberBuy(self.eventActionType, self.packId, 1)
                self:ShowPack()
            end)
        end)
        RxMgr.purchaseProduct:Next(self.packKey)
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

--- @param left number
--- @param max number
function UIEventBigBundleItem:ShowTextBuy(left, max)
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

function UIEventBigBundleItem:CanBuy()
    local numberBought = self.eventPopupModel:GetNumberBuy(self.eventActionType, self.packId)
    return (self.data.stock - numberBought) > 0
end
