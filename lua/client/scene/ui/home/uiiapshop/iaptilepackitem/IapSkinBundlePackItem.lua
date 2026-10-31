--- @class IapSkinBundlePackItem : IconView
IapSkinBundlePackItem = Class(IapSkinBundlePackItem, IconView)

function IapSkinBundlePackItem:Ctor(transform)
    --- @type IapSkinBundlePackItemConfig
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

function IapSkinBundlePackItem:SetPrefabName()
    self.prefabName = 'iap_skin_bundle_pack_item_new'
    self.uiPoolType = UIPoolType.IapSkinBundlePackItem
end

--- @param transform UnityEngine_Transform
function IapSkinBundlePackItem:SetConfig(transform)
    self.config = UIBaseConfig(transform)

    self.itemsTableView = ItemsTableView(self.config.rewardAnchor)

    self:InitButtonListener()
end

function IapSkinBundlePackItem:InitButtonListener()
end

function IapSkinBundlePackItem:AddBuyListener(func)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        func()
    end)
end

function IapSkinBundlePackItem:InitLocalization()

end

--- @param skinId number
function IapSkinBundlePackItem:SetIconDataBySkin(skinId)
    self:GetSkinShopConfig()
    --- @type ProductConfig
    local productConfig = self.skinRawProducts:FindSkinProductBySkinId(skinId)
    local exchangeConfig = self.rawSkinExchangeConfig:GetSkinItemConfigBySkinId(skinId)
    local vipValue
    if productConfig ~= nil then
        vipValue = productConfig:GetReward()
        self:SetRewardList(productConfig.rewardList)
    elseif exchangeConfig ~= nil then
        self:SetRewardList(exchangeConfig.rewardList)
    end

    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas("IconSkinBundlePackNew", skinId)
    self.config.packIcon:SetNativeSize()
end

--- @param productConfig ProductConfig
function IapSkinBundlePackItem:SetIconDataByProductConfig(productConfig)
    self:GetSkinShopConfig()
    self.productConfig = productConfig
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas("IconSkinBundlePackEvent", self.productConfig.id)
    self.config.packIcon:SetNativeSize()
    self:SetRewardList(productConfig.rewardList)
end

--- @param skinId number
function IapSkinBundlePackItem:GetSkinShopConfig()
    --- @type SkinRawProducts
    self.skinRawProducts = ResourceMgr.GetPurchaseConfig():GetCashShop().packConfigDict:Get(OpCode.ITEM_SKIN_BUNDLE_PURCHASE)
    --- @type RawSkinExchangeConfig
    self.rawSkinExchangeConfig = ResourceMgr.GetRawSkinExchangeConfig()
end

function IapSkinBundlePackItem:SetPrice(moneyValue, moneyType)
    if moneyType ~= nil then
        self.config.iconMoney.gameObject:SetActive(true)
        self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(moneyType)
    end
    self.config.textPrice.text = moneyValue
end

--- @param skinId number
function IapSkinBundlePackItem:GetPackConfig()
    self.packId = self.productConfig.id
    self.opCode = self.productConfig.opCode
end

function IapSkinBundlePackItem:SetRewardList(rewardList)
    local viewRewardList = List()
    local vipReward = nil
    --- @param v RewardInBound
    for _, v in ipairs(rewardList:GetItems()) do
        if v.type == ResourceType.Money and v.id == MoneyType.VIP_POINT then
            vipReward = v.number
        else
            viewRewardList:Add(v)
        end
    end

    if vipReward ~= nil and vipReward > 0 then
        self.config.vip:SetActive(true)
        self.config.textVip.text = "+" .. vipReward
    else
        self.config.vip:SetActive(false)
    end

    self:SetActiveColorObject(self.itemsTableView.uiTransform.gameObject, true)
    self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(viewRewardList))

    self:SetViewIconByRarity(viewRewardList)
end

function IapSkinBundlePackItem:SetViewIconByRarity(viewRewardList)
    for i, itemIconData in ipairs(RewardInBound.GetItemIconDataList(viewRewardList):GetItems()) do
        if itemIconData.rarity >= 4 then
            self.itemsTableView:Get(i):ActiveEffectHeroIconTierA(true)
        elseif itemIconData.rarity >= 3 then
            self.itemsTableView:Get(i):ActiveEffectHeroIcon(true)
        else
            self.itemsTableView:Get(i):ActiveEffectHeroIconNormal(true)
        end
    end
end

function IapSkinBundlePackItem:ReturnPool()
    self:OnHide()

    IconView.ReturnPool(self)
end

function IapSkinBundlePackItem:OnHide()
    self:SetActiveColorObject(self.itemsTableView.uiTransform.gameObject, true)
    self.config.iconMoney.gameObject:SetActive(false)
    self.packKey = nil
    self.itemsTableView:Hide()
end

function IapSkinBundlePackItem:OnClickBuy()
    self:RequestBuy()
end

function IapSkinBundlePackItem:RequestBuy()
    BuyUtils.InitListener(function()
        self:OnBuySuccess()
    end)
    self:FireTrackingEvent()
    if self.productConfig.productID ~= nil then
        RxMgr.purchaseProduct:Next(self.productConfig.productID)
    else
        RxMgr.purchaseProduct:Next(self.packKey)
    end
end

function IapSkinBundlePackItem:OnBuySuccess()
    ---self:SetTextBuy()
end

function IapSkinBundlePackItem:SetTextBuy()
    local numberBuy = self.eventPopupModel:GetNumberBuyOpCode(self.productConfig.opCode, self.productConfig.id)

    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - numberBuy, self.productConfig.stock)))

    self:SetActiveColor(numberBuy < self.productConfig.stock)
end

function IapSkinBundlePackItem:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "skin_bundle", self.packId)
end

return IapSkinBundlePackItem