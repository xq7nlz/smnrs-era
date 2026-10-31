--- @class UIIapShopDailyDealHalloweenLayout : UIIapShopLimitedPackLayout
UIIapShopDailyDealHalloweenLayout = Class(UIIapShopDailyDealHalloweenLayout, UIIapShopLimitedPackLayout)

--- @param view UIIapShopView
--- @param packViewType PackViewType
function UIIapShopDailyDealHalloweenLayout:Ctor(view, packViewType)
    UIIapShopLimitedPackLayout.Ctor(self, view, packViewType)
    self.opCode = OpCode.EVENT_HALLOWEEN_DAILY_PURCHASE
end

function UIIapShopDailyDealHalloweenLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("banner_daily_deal_halloween", self.config.bannerView)
    --- @type UIIapShopBannerConfig
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(self.layoutConfig.transform, self.config.bannerView)
    self.layoutConfig.rectTrans.anchoredPosition3D = U_Vector3(165, 250, 0)
end

function UIIapShopDailyDealHalloweenLayout:SetTimeReset()
    self.timeReset = zg.timeMgr:GetRemainingTime()
end

function UIIapShopDailyDealHalloweenLayout:SetUpLayout()
    UIIapShopLimitedPackLayout.SetUpLayout(self)
    self.layoutConfig.gameObject:SetActive(true)
end

function UIIapShopDailyDealHalloweenLayout:InitLocalization()
    self.layoutConfig.bannerTittle.text = LanguageUtils.LocalizeCommon("daily_packs")
end

function UIIapShopDailyDealHalloweenLayout:OnHide()
    UIIapShopLimitedPackLayout.OnHide(self)
    self.layoutConfig.gameObject:SetActive(false)
end

function UIIapShopDailyDealHalloweenLayout:OnPurchaseSuccess()
    self.view:CheckShowNotificationDailyDealHalloween()
end

function UIIapShopDailyDealHalloweenLayout:InitPack()

end

function UIIapShopDailyDealHalloweenLayout:InitPack2()
    local listPack = ResourceMgr.GetPurchaseConfig():GetHalloweenDaily():GetCurrentPack():GetAllPackBase()
    self.listPack = List()
    --- @param id number
    --- @param v LimitedProduct
    for id, v in pairs(listPack:GetItems()) do
        v:SetKey()
        self.listPack:Add(v)
    end
    --ResourceMgr.GetPurchaseConfig():ImportProduct(pack.packDict)
end

function UIIapShopDailyDealHalloweenLayout:OnShow()
    self:InitPack2()
    UIIapShopLimitedPackLayout.OnShow(self)
end