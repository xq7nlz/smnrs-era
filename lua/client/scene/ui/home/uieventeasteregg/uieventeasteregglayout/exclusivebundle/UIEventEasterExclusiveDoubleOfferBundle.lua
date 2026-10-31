--- @class UIEventEasterExclusiveDoubleOfferBundle : UIEventEasterEggLayout
UIEventEasterExclusiveDoubleOfferBundle = Class(UIEventEasterExclusiveDoubleOfferBundle, UIEventEasterEggLayout)

--- @param view UIEventEasterEgg
--- @param tab EasterEggTab
--- @param anchor UnityEngine_RectTransform
function UIEventEasterExclusiveDoubleOfferBundle:Ctor(view, tab, anchor, packId)
    --- @type EasterExclusiveBundleDoubleOfferLayoutConfig
    self.layoutConfig = nil
    UIEventEasterEggLayout.Ctor(self, view, tab, anchor)
    --- thay op code neu co
    self.opCode = OpCode.EVENT_EASTER_EXCLUSIVE_PURCHASE
    --- @type List
    self.rewardList = List()
    --- @type List
    self.rewardItem = List()
    self.packId = packId

    --- @type EventActionType
    self.eventActionType = EventActionType.EASTER_EXCLUSIVE_BUNDLE_PURCHASE
end

function UIEventEasterExclusiveDoubleOfferBundle:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("easter_exclusive_bundle_double_offer", self.anchor)
    UIEventEasterEggLayout.InitLayoutConfig(self, inst)
    self:SetUpLayout()
    self:SetEventTitle()
end

function UIEventEasterExclusiveDoubleOfferBundle:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventEasterExclusiveDoubleOfferBundle:SetEventBanner()
end

function UIEventEasterExclusiveDoubleOfferBundle:SetEventTitle()
    self.layoutConfig.textTitle.text = LanguageUtils.LocalizeCommon("event_easter_exclusive_bundle")
end

function UIEventEasterExclusiveDoubleOfferBundle:SetEventDesc()
end

function UIEventEasterExclusiveDoubleOfferBundle:OnShow()
    self:GetModelConfig()
    self:InitPacks()
    UIEventLayout.OnShow(self)
    --- @type EventEasterEggModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
    --- @type List
    local packList = ResourceMgr.GetPurchaseConfig():GetEasterLimitedOfferStore():GetPack(self.eventModel.timeData.dataId).packList
    ---@param v ProductConfig
    for k, v in pairs(packList:GetItems()) do
        ---@type LunarNewYearExclusiveOfferItem
        local bundleItem = self.packList:Get(k)
        bundleItem:AddListener(function()
            self:OnClickBuy(self.eventModel.timeData.dataId, v, bundleItem)
        end)
        bundleItem:ShowData(self.eventModel.timeData.dataId, v, EventActionType.EASTER_EXCLUSIVE_BUNDLE_PURCHASE)
    end
end

---@param productConfig ProductConfig
---@param obj LunarNewYearExclusiveOfferItem
function UIEventEasterExclusiveDoubleOfferBundle:OnClickBuy(dataId, productConfig, obj)
    local numberBuyData = self.eventModel:GetNumberBuy(EventActionType.EASTER_EXCLUSIVE_BUNDLE_PURCHASE, productConfig.id)
    if numberBuyData > 0 then
        self:AddListener(function()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
        end)
    else
        BuyUtils.InitListener(
                function()
                    self.eventModel:AddNumberBuy(EventActionType.EASTER_EXCLUSIVE_BUNDLE_PURCHASE,
                            productConfig.id, 1)
                    self.view:CheckAllNotificationTab()
                    obj:ShowBuyState(dataId, productConfig, EventActionType.EASTER_EXCLUSIVE_BUNDLE_PURCHASE)
                    obj:SetBuyState(productConfig)
                    RxMgr.notificationPurchasePacks:Next()
                end)
        RxMgr.purchaseProduct:Next(productConfig.productID)
    end
end

function UIEventEasterExclusiveDoubleOfferBundle:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    for i = 1, self.layoutConfig.bundleAnchor.childCount do
        local packView = LunarNewYearExclusiveOfferItem(self.layoutConfig.bundleAnchor:GetChild(i - 1))
        self.packList:Add(packView)
    end
end

function UIEventEasterExclusiveDoubleOfferBundle:OnHide()
    UIEventLayout.OnHide(self)
    self.anchor.gameObject:SetActive(false)
    ---@param v LunarNewYearExclusiveOfferItem
    for _, v in pairs(self.packList:GetItems()) do
        v:ReturnPool()
    end
    self.packList:Clear()
end