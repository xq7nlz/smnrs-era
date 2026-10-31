--- @class UIIapShopDailyDealXmasLayout : UIIapShopLimitedPackLayout
UIIapShopDailyDealXmasLayout = Class(UIIapShopDailyDealXmasLayout, UIIapShopLimitedPackLayout)

--- @param view UIIapShopView
--- @param packViewType PackViewType
function UIIapShopDailyDealXmasLayout:Ctor(view, packViewType)
    UIIapShopLimitedPackLayout.Ctor(self, view, packViewType)
    self.opCode = OpCode.EVENT_HALLOWEEN_DAILY_PURCHASE
end

function UIIapShopDailyDealXmasLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("banner_daily_deal_xmas", self.config.bannerView)
    --- @type UIIapShopBannerConfig
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(self.layoutConfig.transform, self.config.bannerView)
    self.layoutConfig.rectTrans.anchoredPosition3D = U_Vector3(165, 250, 0)
end

function UIIapShopDailyDealXmasLayout:SetTimeReset()
    self.timeReset = zg.timeMgr:GetRemainingTime()
end

function UIIapShopDailyDealXmasLayout:SetUpLayout()
    UIIapShopLimitedPackLayout.SetUpLayout(self)
    self.layoutConfig.gameObject:SetActive(true)
end

function UIIapShopDailyDealXmasLayout:InitLocalization()
    self.layoutConfig.bannerTittle.text = LanguageUtils.LocalizeCommon("daily_packs")
end

function UIIapShopDailyDealXmasLayout:OnHide()
    UIIapShopLimitedPackLayout.OnHide(self)
    self.layoutConfig.gameObject:SetActive(false)
end

function UIIapShopDailyDealXmasLayout:OnPurchaseSuccess()
    self.view:CheckShowNotificationDailyDealXmas()
end

function UIIapShopDailyDealXmasLayout:InitPack()

end

function UIIapShopDailyDealXmasLayout:InitPack2()
    local listPack = ResourceMgr.GetPurchaseConfig():GetXmasDaily():GetCurrentPack():GetAllPackBase()
    self.listPack = List()
    --- @param id number
    --- @param v LimitedProduct
    for id, v in pairs(listPack:GetItems()) do
        v:SetKey()
        self.listPack:Add(v)
    end
end

function UIIapShopDailyDealXmasLayout:OnShow()
    self:InitPack2()
    UIIapShopLimitedPackLayout.OnShow(self)
end