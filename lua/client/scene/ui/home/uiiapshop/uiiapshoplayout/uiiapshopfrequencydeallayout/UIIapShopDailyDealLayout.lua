--- @class UIIapShopDailyDealLayout : UIIapShopLimitedPackLayout
UIIapShopDailyDealLayout = Class(UIIapShopDailyDealLayout, UIIapShopLimitedPackLayout)

function UIIapShopDailyDealLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("banner_daily_deal", self.config.bannerView)
    --- @type UIIapShopBannerConfig
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(self.layoutConfig.transform, self.config.bannerView)
    self.layoutConfig.rectTrans.anchoredPosition3D = U_Vector3(165, 250, 0)
end

function UIIapShopDailyDealLayout:SetTimeReset()
    self.timeReset = zg.timeMgr:GetRemainingTime()
end

function UIIapShopDailyDealLayout:SetUpLayout()
    UIIapShopLimitedPackLayout.SetUpLayout(self)
    self.layoutConfig.gameObject:SetActive(true)
end

function UIIapShopDailyDealLayout:InitLocalization()
    self.layoutConfig.bannerTittle.text = LanguageUtils.LocalizeCommon("daily_packs")
end

function UIIapShopDailyDealLayout:OnHide()
    UIIapShopLimitedPackLayout.OnHide(self)
    self.layoutConfig.gameObject:SetActive(false)
end

function UIIapShopDailyDealLayout:OnPurchaseSuccess()
    self.regularLayout:CheckShowNotificationFreeDeal()
    self.regularLayout.iapShopView:CheckShowNotificationRegularFreeDeal()
end