require "lua.client.scene.ui.home.uiItemPreview.UIItemPreviewChildView"

--- @class UISkinPreviewView : UIBaseView
UISkinPreviewView = Class(UISkinPreviewView, UIBaseView)

--- @return void
--- @param model UISkinPreviewModel
function UISkinPreviewView:Ctor(model)
    ---@type UIItemPreviewChildView
    self.previewChild1 = nil
    --- @type RawSkinExchangeConfig
    self.rawSkinExchangeConfig = nil
    UIBaseView.Ctor(self, model)
    --- @type UISkinPreviewModel
    self.model = model
end

--- @return void
function UISkinPreviewView:OnReadyCreate()
    UIBaseView.OnReadyCreate(self)

    self.rawSkinExchangeConfig = ResourceMgr.GetRawSkinExchangeConfig()

    ---@type UISkinPreviewConfig
    self.config = UIBaseConfig(self.uiTransform)

    self.previewChild1 = UIItemPreviewChildView(self.config.view1)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
    self.config.buttonGoToShop.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickGoToShop()
    end)
end

function UISkinPreviewView:InitLocalization()
    self.config.textBuy.text = LanguageUtils.LocalizeCommon("buy")
    self.config.localizeGoToShop.text = LanguageUtils.LocalizeCommon("go_to_shop")
end

--- @param data {type, id, onBuySuccess}
function UISkinPreviewView:OnReadyShow(data)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    if data ~= nil then
        self.data = data
        --self:ShowButtonBuy()
        self:ShowButtonGoToShop()
        self:Init(data)
    end
end

function UISkinPreviewView:ShowButtonGoToShop()
    if PopupUtils.IsPopupShowing(UIPopupName.UIIapShop) then
        self.config.buttonGoToShop.gameObject:SetActive(false)
    else
        --- @type SkinRawProducts
        local skinRawProducts = ResourceMgr.GetPurchaseConfig():GetCashShop().packConfigDict:Get(OpCode.ITEM_SKIN_BUNDLE_PURCHASE)
        --- @type ProductConfig
        local productConfig = skinRawProducts:FindSkinProductBySkinId(self.data.id)
        self.config.buttonGoToShop.gameObject:SetActive(productConfig ~= nil)
    end
end

function UISkinPreviewView:ShowButtonBuy()
    --- @type {id, moneyType, moneyValue, listRewardInBound, limit}
    local skinItemExchangeConfig = self.rawSkinExchangeConfig:GetSkinItemConfigBySkinId(self.data.id)
    self.config.iconPrice.gameObject:SetActive(skinItemExchangeConfig ~= nil)

    if skinItemExchangeConfig ~= nil then
        self.config.iconPrice.sprite = ResourceLoadUtils.LoadMoneyIcon(skinItemExchangeConfig.moneyType)
        self.config.textPrice.text = skinItemExchangeConfig.moneyValue
    else
        --- @type SkinRawProducts
        local skinRawProducts = ResourceMgr.GetPurchaseConfig():GetCashShop().packConfigDict:Get(OpCode.ITEM_SKIN_BUNDLE_PURCHASE)
        --- @type ProductConfig
        local productConfig = skinRawProducts:FindSkinProductBySkinId(self.data.id)
        self.config.buttonBuy.gameObject:SetActive(productConfig ~= nil)
        if productConfig ~= nil then
            self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(productConfig.productID)
        end
    end
end

function UISkinPreviewView:Init(result)
    if result then
        self.previewChild1:Show(result)
        local skinId = result.id
        local heroId = ClientConfigUtils.GetHeroIdBySkinId(skinId)
        if self.worldSpaceHeroView == nil then
            ---@type UnityEngine_Transform
            local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
            self.worldSpaceHeroView = WorldSpaceHeroView(trans)
            local renderTexture = U_RenderTexture(1600, 1600, 24, U_RenderTextureFormat.ARGB32)
            self.config.rawImage.texture = renderTexture
            self.worldSpaceHeroView:Init(renderTexture)
        end
        local heroResource = HeroResource()
        heroResource:SetData(-1, heroId, 1, 1)
        heroResource.heroItem:Add(HeroItemSlot.SKIN, skinId)
        self.worldSpaceHeroView:ShowHero(heroResource)
        self.worldSpaceHeroView.config.transform.position = U_Vector3(99000, 99000, 0)
        self.worldSpaceHeroView.config.bg:SetActive(false)
        --self.worldSpaceHeroView:SetDefaultHeroScale()
        self.worldSpaceHeroView.previewHero:SetScale(0.9)
    end
end

--- @return void
function UISkinPreviewView:Hide()
    UIBaseView.Hide(self)
    if self.previewChild1 ~= nil then
        self.previewChild1:Hide()
    end
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
    self.config.buttonGoToShop.gameObject:SetActive(false)
end

function UISkinPreviewView:OnClickBuy()
    --- @type {id, moneyType, moneyValue, listRewardInBound, limit}
    local skinItemExchangeConfig = self.rawSkinExchangeConfig:GetSkinItemConfigBySkinId(self.data.id)
    if skinItemExchangeConfig ~= nil then
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_buy"), nil,
                function()
                    self:RequestSkinExchange(skinItemExchangeConfig)
                end)
    else
        self:RequestSkinPurchase(self.data.id)
    end
end

function UISkinPreviewView:OnClickGoToShop()
    if PopupUtils.IsPopupShowing(UIPopupName.UIInventory) then
        PopupMgr.HidePopup(UIPopupName.UIInventory)
    end
    if PopupUtils.IsPopupShowing(UIPopupName.UISkinCollection) then
        PopupMgr.HidePopup(UIPopupName.UISkinCollection)
    end

    if PopupUtils.IsPopupShowing(UIPopupName.UIEventSkinChallenge) then
        PopupMgr.HidePopup(UIPopupName.UIEventSkinChallenge)
    end

    if PopupUtils.IsPopupShowing(UIPopupName.UIEventHalloween) then
        PopupMgr.HidePopup(UIPopupName.UIEventHalloween)
    end

    if PopupUtils.IsPopupShowing(UIPopupName.UIEventSeasonal) then
        PopupMgr.HidePopup(UIPopupName.UIEventSeasonal)
    end
    PopupMgr.ShowAndHidePopup(UIPopupName.UIIapShop, IapShopTab.SKIN, UIPopupName.UISkinPreview)
end

--- @type {id, moneyType, moneyValue, listRewardInBound, limit}
function UISkinPreviewView:RequestSkinExchange(skinItemExchangeConfig)
    local price = RewardInBound.CreateBySingleParam(ResourceType.Money, skinItemExchangeConfig.moneyType, skinItemExchangeConfig.moneyValue)
    if InventoryUtils.IsEnoughSingleResourceRequirement(price) == false then
        return
    end
    --- @type List
    local listReward
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        listReward = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
    end
    local onSuccess = function()
        if listReward ~= nil then
            PopupUtils.ClaimAndShowRewardList(listReward)
            InventoryUtils.Sub(price.type, price.id, price.number)
        end
        self:OnReadyHide()
        if self.data.onBuySuccess then
            self.data.onBuySuccess(true)
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.ITEM_SKIN_EXCHANGE,
            UnknownOutBound.CreateInstance(PutMethod.Int, skinItemExchangeConfig.id),
            onSuccess, nil, onBufferReading)
end

function UISkinPreviewView:RequestSkinPurchase()
    --- @type SkinRawProducts
    local skinRawProducts = ResourceMgr.GetPurchaseConfig():GetCashShop().packConfigDict:Get(OpCode.ITEM_SKIN_BUNDLE_PURCHASE)
    --- @type ProductConfig
    local productConfig = skinRawProducts:FindSkinProductBySkinId(self.data.id)

    BuyUtils.InitListener(function()
        self:OnReadyHide()
        TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "raw_skin_bundle", productConfig.productID)
        if self.data.onBuySuccess then
            self.data.onBuySuccess(false)
        end
    end)
    RxMgr.purchaseProduct:Next(productConfig.productID)
end