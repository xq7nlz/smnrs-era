--- @class UIIapShopDailyDealNewYearLayout : UIIapShopLimitedPackLayout
UIIapShopDailyDealNewYearLayout = Class(UIIapShopDailyDealNewYearLayout, UIIapShopLimitedPackLayout)

--- @param view UIIapShopView
--- @param packViewType PackViewType
function UIIapShopDailyDealNewYearLayout:Ctor(view, packViewType)
    UIIapShopLimitedPackLayout.Ctor(self, view, packViewType)
    self.opCode = OpCode.EVENT_NEW_YEAR_BUNDLE_PURCHASE
end

function UIIapShopDailyDealNewYearLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("banner_daily_deal_new_year", self.config.bannerView)
    --- @type UIIapShopBannerConfig
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(self.layoutConfig.transform, self.config.bannerView)
    self.layoutConfig.rectTrans.anchoredPosition3D = U_Vector3(165, 250, 0)
end

function UIIapShopDailyDealNewYearLayout:SetTimeReset()
    self.timeReset = zg.timeMgr:GetRemainingTime()
end

function UIIapShopDailyDealNewYearLayout:SetUpLayout()
    UIIapShopLimitedPackLayout.SetUpLayout(self)
    self.layoutConfig.gameObject:SetActive(true)
end

function UIIapShopDailyDealNewYearLayout:InitLocalization()
    self.layoutConfig.bannerTittle.text = LanguageUtils.LocalizeCommon("daily_packs")
end

function UIIapShopDailyDealNewYearLayout:OnHide()
    UIIapShopLimitedPackLayout.OnHide(self)
    self.layoutConfig.gameObject:SetActive(false)
end

function UIIapShopDailyDealNewYearLayout:OnPurchaseSuccess()
    self.view:CheckShowNotificationDailyDealNewYear()
end

function UIIapShopDailyDealNewYearLayout:InitPack()

end

function UIIapShopDailyDealNewYearLayout:InitPack2()
    local listPack = ResourceMgr.GetPurchaseConfig():GetNewYearBundle():GetCurrentPack():GetAllPackBase()
    self.listPack = List()
    --- @param v LimitedProduct
    for _, v in pairs(listPack:GetItems()) do
        v:SetKey()
        self.listPack:Add(v)
    end
end

function UIIapShopDailyDealNewYearLayout:OnShow()
    self:InitPack2()
    UIIapShopLimitedPackLayout.OnShow(self)
end