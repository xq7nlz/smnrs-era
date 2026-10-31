--- @class UIIapShopDailyDealBirthdayLayout : UIIapShopLimitedPackLayout
UIIapShopDailyDealBirthdayLayout = Class(UIIapShopDailyDealBirthdayLayout, UIIapShopLimitedPackLayout)

--- @param view UIIapShopView
--- @param packViewType PackViewType
function UIIapShopDailyDealBirthdayLayout:Ctor(view, packViewType)
    UIIapShopLimitedPackLayout.Ctor(self, view, packViewType)
    self.opCode = OpCode.EVENT_EASTER_DAILY_BUNDLE_PURCHASE
end

function UIIapShopDailyDealBirthdayLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("banner_daily_deal_birthday", self.config.bannerView)
    --- @type UIIapShopBannerConfig
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(self.layoutConfig.transform, self.config.bannerView)
    self.layoutConfig.rectTrans.anchoredPosition3D = U_Vector3(165, 250, 0)
end

function UIIapShopDailyDealBirthdayLayout:SetTimeReset()
    self.timeReset = zg.timeMgr:GetRemainingTime()
end

function UIIapShopDailyDealBirthdayLayout:SetUpLayout()
    UIIapShopLimitedPackLayout.SetUpLayout(self)
    self.layoutConfig.gameObject:SetActive(true)
end

function UIIapShopDailyDealBirthdayLayout:InitLocalization()
    self.layoutConfig.bannerTittle.text = LanguageUtils.LocalizeCommon("daily_packs")
end

function UIIapShopDailyDealBirthdayLayout:OnHide()
    UIIapShopLimitedPackLayout.OnHide(self)
    self.layoutConfig.gameObject:SetActive(false)
end

function UIIapShopDailyDealBirthdayLayout:OnPurchaseSuccess()
    self.view:CheckShowNotificationDailyDealBirthday()
end

function UIIapShopDailyDealBirthdayLayout:InitPack()

end

function UIIapShopDailyDealBirthdayLayout:InitPack2()
    local listPack = ResourceMgr.GetPurchaseConfig():GetBirthdayDailyBundleStore():GetCurrentPack():GetAllPackBase()
    self.listPack = List()
    --- @param _ number
    --- @param v LimitedProduct
    for _, v in pairs(listPack:GetItems()) do
        v:SetKey()
        self.listPack:Add(v)
    end
end

function UIIapShopDailyDealBirthdayLayout:OnShow()
    self:InitPack2()
    UIIapShopLimitedPackLayout.OnShow(self)
end