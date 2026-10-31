--- @class UIIapShopDailyDealEasterLayout : UIIapShopLimitedPackLayout
UIIapShopDailyDealEasterLayout = Class(UIIapShopDailyDealEasterLayout, UIIapShopLimitedPackLayout)

--- @param view UIIapShopView
--- @param packViewType PackViewType
function UIIapShopDailyDealEasterLayout:Ctor(view, packViewType)
    UIIapShopLimitedPackLayout.Ctor(self, view, packViewType)
    self.opCode = OpCode.EVENT_EASTER_DAILY_BUNDLE_PURCHASE
end

function UIIapShopDailyDealEasterLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("banner_daily_deal_easter", self.config.bannerView)
    --- @type UIIapShopBannerConfig
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(self.layoutConfig.transform, self.config.bannerView)
    self.layoutConfig.rectTrans.anchoredPosition3D = U_Vector3(165, 250, 0)
end

function UIIapShopDailyDealEasterLayout:SetTimeReset()
    self.timeReset = zg.timeMgr:GetRemainingTime()
end

function UIIapShopDailyDealEasterLayout:SetUpLayout()
    UIIapShopLimitedPackLayout.SetUpLayout(self)
    self.layoutConfig.gameObject:SetActive(true)
end

function UIIapShopDailyDealEasterLayout:InitLocalization()
    self.layoutConfig.bannerTittle.text = LanguageUtils.LocalizeCommon("daily_packs")
end

function UIIapShopDailyDealEasterLayout:OnHide()
    UIIapShopLimitedPackLayout.OnHide(self)
    self.layoutConfig.gameObject:SetActive(false)
end

function UIIapShopDailyDealEasterLayout:OnPurchaseSuccess()
    self.view:CheckShowNotificationDailyDealEaster()
end

function UIIapShopDailyDealEasterLayout:InitPack()

end

function UIIapShopDailyDealEasterLayout:InitPack2()
    local listPack = ResourceMgr.GetPurchaseConfig():GetEasterDailyBundleStore():GetCurrentPack():GetAllPackBase()
    self.listPack = List()
    --- @param id number
    --- @param v LimitedProduct
    for id, v in pairs(listPack:GetItems()) do
        v:SetKey()
        self.listPack:Add(v)
    end
end

function UIIapShopDailyDealEasterLayout:OnShow()
    self:InitPack2()
    UIIapShopLimitedPackLayout.OnShow(self)
end