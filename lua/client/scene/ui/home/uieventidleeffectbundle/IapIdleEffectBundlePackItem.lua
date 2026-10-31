--- @class IapIdleEffectBundlePackItem : IconView
IapIdleEffectBundlePackItem = Class(IapIdleEffectBundlePackItem, IconView)

function IapIdleEffectBundlePackItem:Ctor(transform)
    --- @type IapIdleEffectBundlePackItemConfig
    self.config = nil
    --- @type OpCode
    self.opCode = nil
    --- @type number
    self.packId = nil
    --- @type number
    self.packKey = nil
    --- @type ItemsTableView
    self.itemsTableView = nil

    if transform then
        self:SetConfig(transform)
    else
        IconView.Ctor(self)
    end
end

function IapIdleEffectBundlePackItem:SetPrefabName()
    self.prefabName = 'iap_idle_effect_bundle_pack_item'
    self.uiPoolType = UIPoolType.IapIdleEffectBundlePackItem
end

--- @param transform UnityEngine_Transform
function IapIdleEffectBundlePackItem:SetConfig(transform)
    self.config = UIBaseConfig(transform)
    self.itemsTableView = ItemsTableView(self.config.rewardAnchor)
    self:InitButtonListener()
end

function IapIdleEffectBundlePackItem:InitButtonListener()
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
end

function IapIdleEffectBundlePackItem:InitLocalization()

end

--- @param productConfig ProductConfig
function IapIdleEffectBundlePackItem:SetIconData(productConfig)
    self.productConfig = productConfig
    --- @type EventPopupModel
    self.eventPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_IDLE_EFFECT_BUNDLE)
    self:SetPackKey()
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    self:SetRewardList()
    self.config.packIcon:SetNativeSize()
end

function IapIdleEffectBundlePackItem:SetPackKey()
    self.packId = self.productConfig.id
    self.opCode = self.productConfig.opCode
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId, self.eventPopupModel.timeData.dataId)
end

function IapIdleEffectBundlePackItem:SetRewardList(rewardList)
    local vipValue, productRewards = self.productConfig:GetReward()
    rewardList = rewardList or productRewards

    self:SetActiveColorObject(self.itemsTableView.uiTransform.gameObject, true)
    self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(rewardList))

    if vipValue ~= nil and vipValue > 0 then
        self.config.vip:SetActive(true)
        self.config.textVip.text = "+" .. vipValue
    else
        self.config.vip:SetActive(false)
    end

    self:SetTextBuy()
end

function IapIdleEffectBundlePackItem:ReturnPool()
    self:OnHide()

    IconView.ReturnPool(self)
end

function IapIdleEffectBundlePackItem:OnHide()
    self:SetActiveColorObject(self.itemsTableView.uiTransform.gameObject, true)
    self.itemsTableView:Hide()
end

function IapIdleEffectBundlePackItem:OnClickBuy()
    local numberBuy = self.eventPopupModel:GetNumberBuyOpCode(self.productConfig.opCode, self.productConfig.id)
    if numberBuy < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function IapIdleEffectBundlePackItem:RequestBuy()
    BuyUtils.InitListener(function()
        self:OnBuySuccess()
    end)
    self:FireTrackingEvent()
    RxMgr.purchaseProduct:Next(self.packKey)
end

function IapIdleEffectBundlePackItem:OnBuySuccess()
    self:SetTextBuy()
end

function IapIdleEffectBundlePackItem:SetTextBuy()
    local numberBuy = self.eventPopupModel:GetNumberBuyOpCode(self.productConfig.opCode, self.productConfig.id)

    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - numberBuy, self.productConfig.stock)))

    self:SetActiveColor(numberBuy < self.productConfig.stock)
end

function IapIdleEffectBundlePackItem:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "idle_effect_bundle", self.packId)
end

return IapIdleEffectBundlePackItem