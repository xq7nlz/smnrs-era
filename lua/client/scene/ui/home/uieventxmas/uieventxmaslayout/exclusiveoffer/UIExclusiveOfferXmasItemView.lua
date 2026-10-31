--- @class UIExclusiveOfferXmasItemView
UIExclusiveOfferXmasItemView = Class(UIExclusiveOfferXmasItemView)

--- @param transform UnityEngine_Transform
function UIExclusiveOfferXmasItemView:Ctor(transform)
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
    --- @type EventXmasModel
    self.eventModel = nil

    self:InitButtonListener()
    self:InitItemTableView()
end

function UIExclusiveOfferXmasItemView:InitButtonListener()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
end

function UIExclusiveOfferXmasItemView:InitItemTableView()
    self.itemsTable = ItemsTableView(self.config.resAnchor)
end

function UIExclusiveOfferXmasItemView:OnShow(packId, dataId)
    self.dataId = dataId
    self.packId = packId
    self.data = ResourceMgr.GetPurchaseConfig():GetXmasExclusive():GetPack(self.dataId):GetPackBase(self.packId)
    self.opCode = self.data.opCode
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId, dataId)
    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
    self.config.tittle.text = LanguageUtils.LocalizeCommon(string.format("xmas_purchase_%d", self.packId))

    self:ShowPack()
    self:SetPrice()
end

function UIExclusiveOfferXmasItemView:ShowPack()
    LanguageUtils.CheckInitLocalize(self, UIExclusiveOfferXmasItemView.InitLocalization)
    ---- @type EventXmasProduct
    local vipText, rewardList = self.data:GetReward()
    self:SetInstantReward(rewardList)
    self:SetVipText(vipText)

    local numberBought = self.eventModel:GetNumberBuy(EventActionType.CHRISTMAS_EXCLUSIVE_OFFER_PURCHASE, self.packId)
    local left = self.data.stock
    left = self.data.stock - numberBought
    self:ShowTextBuy(left, self.data.stock)
end

function UIExclusiveOfferXmasItemView:SetPrice()
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    --  XDebug.Log("pack key: "..tostring(self.packKey))
end

function UIExclusiveOfferXmasItemView:SetInstantReward(rewardList)
    self.itemsTable:SetData(RewardInBound.GetItemIconDataList(rewardList), UIPoolType.ItemInfoView)
end

function UIExclusiveOfferXmasItemView:SetVipText(vipText)
    self.config.vipText.text = "+" .. tostring(vipText)
end

function UIExclusiveOfferXmasItemView:Hide()
    self.itemsTable:Hide()
end

function UIExclusiveOfferXmasItemView:OnClickBuy()
    if self:CanBuy() then
        local data = ResourceMgr.GetPurchaseConfig():GetXmasExclusive():GetPack(self.dataId):GetPackBase(self.packId)
        local packKey = self.packKey
        if data ~= nil then
            packKey = ClientConfigUtils.GetPurchaseKey(data.opCode, data.id, data.dataId)
        end
        BuyUtils.InitListener(function()
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, function()
                self.eventModel:AddNumberBuy(EventActionType.CHRISTMAS_EXCLUSIVE_OFFER_PURCHASE, self.packId, 1)
                self:ShowPack()
            end)
        end)
        RxMgr.purchaseProduct:Next(packKey)
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

--- @param left number
--- @param max number
function UIExclusiveOfferXmasItemView:ShowTextBuy(left, max)
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

function UIExclusiveOfferXmasItemView:CanBuy()
    local numberBought = self.eventModel:GetNumberBuy(EventActionType.CHRISTMAS_EXCLUSIVE_OFFER_PURCHASE, self.packId)
    return (self.data.stock - numberBought) > 0
end
