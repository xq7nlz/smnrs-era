require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopCustomizeBundleLayout.UICustomPackView"

--- @class UIIapShopCustomizeBundleLayout : UIIapShopLayout
UIIapShopCustomizeBundleLayout = Class(UIIapShopCustomizeBundleLayout, UIIapShopLayout)

--- @param view UIIapShopView
function UIIapShopCustomizeBundleLayout:Ctor(view, parent)
    --- @type List -- UICustomPackView
    self.packList = nil
    --- @type UIIapShopCustomizeBundleLayoutConfig
    self.layoutConfig = nil
    UIIapShopLayout.Ctor(self, view, parent)
end

--- @param parent UnityEngine_RectTransform
function UIIapShopCustomizeBundleLayout:InitLayoutConfig(parent)
    local inst = PrefabLoadUtils.Instantiate("customize_bundle_view", parent)
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(inst.transform, parent)
    inst:SetActive(true)

    self:InitPack()
end

function UIIapShopCustomizeBundleLayout:InitLocalization()
    if self.packList then
        --- @param v UICustomPackView
        for _, v in pairs(self.packList:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIIapShopCustomizeBundleLayout:InitPack()
    --- @param obj UICustomPackView
    local onCreateItem = function(obj, index)
        index = index + 1
        --- @type CustomizeProduct
        local customizeProduct = self.listCustomizeProduct:Get(index)

        obj:SetData(customizeProduct)
    end

    self.uiScroll = UILoopScroll(self.layoutConfig.scrollHorizontal, UIPoolType.UICustomPackView, onCreateItem)
end

--- @param iapShopTab IapShopTab
function UIIapShopCustomizeBundleLayout:OnShow(iapShopTab)
    --- @type PackOfProducts
    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetCashShop():GetCustomizeProducts()

    self.listCustomizeProduct = List()
    --- @param id number
    --- @param v CustomizeProduct
    for id, v in pairs(self.packOfProducts.packDict:GetItems()) do
        self.listCustomizeProduct:Add(v)
    end

    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)

    self.config.customizeBundleView.gameObject:SetActive(true)
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "customize_bundle")

    self.uiScroll:Resize(self.listCustomizeProduct:Count())
    self.isShowing = true
end

function UIIapShopCustomizeBundleLayout:OnHide()
    self.uiScroll:Hide()
end