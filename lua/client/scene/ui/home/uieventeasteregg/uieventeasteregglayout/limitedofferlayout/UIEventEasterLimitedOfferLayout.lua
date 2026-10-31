--- @class UIEventEasterLimitedOfferLayout : UIEventEasterEggLayout
UIEventEasterLimitedOfferLayout = Class(UIEventEasterLimitedOfferLayout, UIEventEasterEggLayout)

--- @param view UIEventEasterEggView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventEasterLimitedOfferLayout:Ctor(view, eventTimeType, anchor)
    --- @type EasterLimitedOfferLayoutConfig
    self.layoutConfig = nil
    --- @type EventEasterEggModel
    self.eventModel = nil
    --- @type ProductConfig
    self.productConfig = nil
    --- @type UILoopScroll
    self.scrollItems = nil
    --- @type EventActionType
    self.eventActionType = EventActionType.EASTER_LIMIT_OFFER_PURCHASE
    UIEventEasterEggLayout.Ctor(self, view, eventTimeType, anchor)
end

function UIEventEasterLimitedOfferLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("easter_limited_offer_layout", self.anchor)
    UIEventEasterEggLayout.InitLayoutConfig(self, inst)

    self.layoutConfig.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)

    self:InitLocalization()
    self:InitScroll()
end

function UIEventEasterLimitedOfferLayout:InitLocalization()
    UIEventEasterEggLayout.InitLocalization(self)

    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("event_easter_limited_offer_tittle")
end

function UIEventEasterLimitedOfferLayout:InitScroll()
    --- @param obj ItemWithNameInfoView
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        obj:SetIconData(self.listItems:Get(dataIndex))
        obj:EnableBgHighlight(dataIndex == 1)
        obj:ActiveMaskSelect(self.isUnlocked)
    end
    self.scrollItems = UILoopScroll(self.layoutConfig.scrollContent, UIPoolType.ItemWithNameInfoView, onCreateItem)
end

function UIEventEasterLimitedOfferLayout:GetModelConfig()
    UIEventEasterEggLayout.GetModelConfig(self)
end

function UIEventEasterLimitedOfferLayout:OnShow()
    UIEventEasterEggLayout.OnShow(self)
    local allPacks = ResourceMgr.GetPurchaseConfig():GetEasterLimitedOfferStore():GetCurrentPack()
    self.productConfig = allPacks:GetAllPackBase():Get(1)
    self.listItems = self.productConfig:GetRewardList()
    self:SetPackKey()
    self:ShowStatus()
end

function UIEventEasterLimitedOfferLayout:SetPackKey()
    self.packId = self.productConfig.id
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.productConfig.opCode, self.packId, self.eventModel.timeData.dataId)
    self.layoutConfig.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
end

function UIEventEasterLimitedOfferLayout:ShowStatus()
    self.isUnlocked = not self:CanBuy()

    self.layoutConfig.buttonBuy.gameObject:SetActive(not self.isUnlocked)
    if not self.isUnlocked then
        self.layoutConfig.textLimit.text = string.format(LanguageUtils.LocalizeCommon("limit_x"),
                string.format("%s/%s",
                        self.productConfig.stock - self.eventModel:GetNumberBuy(self.eventActionType, self.packId),
                        self.productConfig.stock))
    else
        self.layoutConfig.textLimit.text = LanguageUtils.LocalizeCommon("purchased")
    end

    self.scrollItems:Resize(self.listItems:Count())
end

function UIEventEasterLimitedOfferLayout:OnHide()
    UIEventEasterEggLayout.OnHide(self)
    self.scrollItems:Hide()
end

function UIEventEasterLimitedOfferLayout:OnClickBuy()
    BuyUtils.InitListener(function()
        self:GetModelConfig()
        self:ShowStatus()
    end)
    RxMgr.purchaseProduct:Next(self.packKey)
end

function UIEventEasterLimitedOfferLayout:CanBuy()
    local numberBought = self.eventModel:GetNumberBuy(self.eventActionType, self.packId)
    return (self.productConfig.stock - numberBought) > 0
end