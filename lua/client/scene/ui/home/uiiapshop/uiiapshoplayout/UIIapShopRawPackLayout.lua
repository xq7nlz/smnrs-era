--- @class UIIapShopRawPackLayout : UIIapShopLayout
UIIapShopRawPackLayout = Class(UIIapShopRawPackLayout, UIIapShopLayout)

local MAX_NUMBER_VIEWPORT = 6

--- @param view UIIapShopView
---- @param packViewType PackViewType
function UIIapShopRawPackLayout:Ctor(view, packViewType)
    self.opCode = OpCode.PURCHASE_RAW_PACK
    self.packViewType = packViewType
    UIIapShopLayout.Ctor(self, view)
    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPack(self.opCode)
end

function UIIapShopRawPackLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("banner_raw_pack", self.config.bannerView)
    --- @type UIIapShopBannerConfig
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(self.layoutConfig.transform, self.config.bannerView)
    self.layoutConfig.rectTrans.anchoredPosition3D = U_Vector3(165, 250, 0)
end

function UIIapShopRawPackLayout:InitScroll()
    --- @param obj IapTilePackItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type LimitedProduct
        local limitedProduct = self.packOfProducts:GetPackBase(dataIndex)
        obj:SetViewIconData(self.packViewType, limitedProduct)
    end
    self.uiScroll = UILoopScroll(self.config.scrollVertical, UIPoolType.IapTilePackItem, onCreateItem)
    if self.packOfProducts:GetAllPackBase():Count() < MAX_NUMBER_VIEWPORT then
        self.uiScroll.scroll.enabled = false
    end
end

function UIIapShopRawPackLayout:OnShow()
    UIIapShopLayout.OnShow(self)
    self.uiScroll:Resize(self.packOfProducts:GetAllPackBase():Count())
end

function UIIapShopRawPackLayout:SetUpLayout()
    UIIapShopLayout.SetUpLayout(self)
    self.config.scrollVertical.gameObject:SetActive(true)
    self.config.bannerView.gameObject:SetActive(true)
    self.layoutConfig.gameObject:SetActive(true)
    self:InitScroll()
end

function UIIapShopRawPackLayout:OnHide()
    UIIapShopLayout.OnHide(self)
    self.uiScroll:Hide()
    self.layoutConfig.gameObject:SetActive(false)
end

function UIIapShopRawPackLayout:InitLocalization()
    self.layoutConfig.bannerTittle.text = LanguageUtils.LocalizeCommon("raw_packs")
end