--- @class UIEventLunarBundleDoubleOfferLayout : UIEventLunarNewYearLayout
UIEventLunarBundleDoubleOfferLayout = Class(UIEventLunarBundleDoubleOfferLayout, UIEventLunarNewYearLayout)

--- @param view UIEventNewYearView
--- @param newYearTab LunarNewYearTab
--- @param anchor UnityEngine_RectTransform
function UIEventLunarBundleDoubleOfferLayout:Ctor(view, newYearTab, anchor, packId)
    --- @type LunarNewYearExclusiveDoubleOfferLayout
    self.layoutConfig = nil
    UIEventLunarNewYearLayout.Ctor(self, view, newYearTab, anchor)
    --- thay op code neu co
    self.opCode = OpCode.EVENT_LUNAR_2022_BUNDLE_PURCHASE
    --- @type List
    self.rewardList = List()
    --- @type List
    self.rewardItem = List()
    --- @type List
    self.packList = List()
    self.packId = packId
end

function UIEventLunarBundleDoubleOfferLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("lunar_new_year_lunar_exclusive_bundle_double_offer", self.anchor)
    UIEventLunarNewYearLayout.InitLayoutConfig(self, inst)
    self:SetUpLayout()
    self:SetEventTitle()
end

function UIEventLunarBundleDoubleOfferLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventLunarBundleDoubleOfferLayout:SetEventTitle()
    self.layoutConfig.titleText.text = LanguageUtils.LocalizeCommon("event_lunar_new_year_exclusive_bundle")
end

function UIEventLunarBundleDoubleOfferLayout:OnShow()
    self:GetModelConfig()
    self:InitPacks()
    UIEventLayout.OnShow(self)
    --- @type EventLunarNewYearModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2022)
    --- @type List
    local packList = ResourceMgr.GetPurchaseConfig():GetLunarExclusiveStore():GetPack(self.eventModel.timeData.dataId).packList
    ---@param v ProductConfig
    for k, v in pairs(packList:GetItems()) do
        ---@type LunarNewYearExclusiveOfferItem
        local bundleItem = self.packList:Get(k)
        bundleItem:AddListener(function()
            self:OnClickBuy(self.eventModel.timeData.dataId, v, bundleItem)
        end)
        bundleItem:ShowData(self.eventModel.timeData.dataId, v, EventActionType.EVENT_LUNAR_2022_EXCLUSIVE_BUNDLE_PURCHASE)
    end
end

---@param productConfig ProductConfig
---@param obj LunarNewYearExclusiveOfferItem
function UIEventLunarBundleDoubleOfferLayout:OnClickBuy(dataId, productConfig, obj)
    local numberBuyData = self.eventModel:GetNumberBuy(EventActionType.EVENT_LUNAR_2022_EXCLUSIVE_BUNDLE_PURCHASE, productConfig.id)
    if numberBuyData > 0 then
        self:AddListener(function()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
        end)
    else
        BuyUtils.InitListener(
                function()
                    self.eventModel:AddNumberBuy(EventActionType.EVENT_LUNAR_2022_EXCLUSIVE_BUNDLE_PURCHASE,
                            productConfig.id, 1)
                    self.view:CheckAllNotificationTab()
                    obj:ShowBuyState(dataId, productConfig, EventActionType.EVENT_LUNAR_2022_EXCLUSIVE_BUNDLE_PURCHASE)
                    obj:SetBuyState(productConfig)
                    RxMgr.notificationPurchasePacks:Next()
                end)
        RxMgr.purchaseProduct:Next(productConfig.productID)
    end
end

function UIEventLunarBundleDoubleOfferLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    for i = 1, self.layoutConfig.bundleAnchor.childCount do
        local packView = LunarNewYearExclusiveOfferItem(self.layoutConfig.bundleAnchor:GetChild(i - 1))
        self.packList:Add(packView)
    end
end

function UIEventLunarBundleDoubleOfferLayout:OnHide()
    UIEventLayout.OnHide(self)
    ---@param v LunarNewYearExclusiveOfferItem
    for _, v in pairs(self.packList:GetItems()) do
        v:ReturnPool()
    end
    self.packList:Clear()
end