require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopRegularLayout.IapShopRegularTabItem"

--- @class UIIapShopRegularLayout: UIIapShopLayout
UIIapShopRegularPackLayout = Class(UIIapShopRegularPackLayout, UIIapShopLayout)

--- @param view UIIapShopView
--- @param parent UnityEngine_RectTransform
--- @param eventTimeType EventTimeType
function UIIapShopRegularPackLayout:Ctor(view, parent)
    self.eventTimeType = eventTimeType
    --- @type UIIapShopRegularPackLayoutConfig
    self.regularLayoutConfig = nil
    --- @type EventArenaPassModel
    self.eventPassModel = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIIapShopLayout
    self.layout = nil
    --- @type UIIapShopView
    self.iapShopView = view

    --- @type Dictionary
    self.tabDict = Dictionary()
    UIIapShopLayout.Ctor(self, view, parent)
end

--- @param parent UnityEngine_RectTransform
function UIIapShopRegularPackLayout:InitLayoutConfig(parent)
    local inst = PrefabLoadUtils.Instantiate("regular_pack_shop", parent)
    self.regularLayoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(inst.transform, parent)
    inst:SetActive(true)

    self:InitListRegularDealTab()
end

--- @param iapShopTab IapShopTab
function UIIapShopRegularPackLayout:OnShow(iapShopTab)
    self.config.regularPackView.gameObject:SetActive(true)
    self:OnSelectTab(1)
    self.isShowing = true
end

function UIIapShopRegularPackLayout:OnHide()
    self.config.regularPackView.gameObject:SetActive(false)
    self.isShowing = false
    if self.layout ~= nil then
        self.layout:OnHide()
    end
end

function UIIapShopRegularPackLayout:InitListRegularDealTab()
    for i = 1, self.regularLayoutConfig.listPackHeader.childCount do
        --- @type IapShopRegularTabItem
        local tab = IapShopRegularTabItem(self.regularLayoutConfig.listPackHeader:GetChild(i - 1))
        tab:SetListener(function()
            self:OnSelectTab(i)
        end)
        self.tabDict:Add(i, tab)
    end
end


--- @param iapShopRegularTab IapShopRegularTab
function UIIapShopRegularPackLayout:OnSelectTab(iapShopRegularTab)
    self:CheckShowNotificationFreeDeal()
    --- @param v IapShopRegularTabItem
    for k, v in pairs(self.tabDict:GetItems()) do
        v:SetTabState(k == iapShopRegularTab)
    end
    self:GetLayout(iapShopRegularTab)
    self.layout:OnShow(iapShopRegularTab)
end

--- @param iapShopRegularTab IapShopRegularTab
function UIIapShopRegularPackLayout:GetLayout(iapShopRegularTab)
    if self.layout ~= nil then
        self.layout:OnHide()
    end
    self.layout = self.layoutDict:Get(iapShopRegularTab)
    if self.layout == nil then
        if iapShopRegularTab == IapShopRegularTab.DAILY_DEAL then
            require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopFrequencyDealLayout.UIIapShopDailyDealLayout"
            self.layout = UIIapShopDailyDealLayout(self, PackViewType.DAILY_LIMITED_PACK)
        elseif iapShopRegularTab == IapShopRegularTab.WEEKLY_DEAL then
            require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopFrequencyDealLayout.UIIapShopWeeklyDealLayout"
            self.layout = UIIapShopWeeklyDealLayout(self, PackViewType.WEEKLY_LIMITED_PACK)
        elseif iapShopRegularTab == IapShopRegularTab.MONTHLY_DEAL then
            require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopFrequencyDealLayout.UIIapShopMonthlyDealLayout"
            self.layout = UIIapShopMonthlyDealLayout(self, PackViewType.MONTHLY_LIMITED_PACK)
        else
            XDebug.Error("Missing layout of type " .. iapShopTab)
        end
        self.layout:InitLocalization()
        self.layoutDict:Add(IapShopRegularTab, self.layout)
    end
end

--- @return string
--- @param iapShopRegularTab IapShopRegularTab
function UIIapShopRegularPackLayout:GetTabName(iapShopRegularTab)
    if iapShopRegularTab == IapShopRegularTab.DAILY_DEAL then
        return LanguageUtils.LocalizeCommon("daily_packs")
    elseif iapShopRegularTab == IapShopRegularTab.WEEKLY_DEAL then
        return LanguageUtils.LocalizeCommon("weekly_packs")
    elseif iapShopRegularTab == IapShopRegularTab.MONTHLY_DEAL then
        return LanguageUtils.LocalizeCommon("monthly_packs")
    end
end

function UIIapShopRegularPackLayout:InitLocalization()
    --- @param v IapShopTabItem
    for k, v in pairs(self.tabDict:GetItems()) do
        v:SetTabName(self:GetTabName(k))
    end
end

function UIIapShopRegularPackLayout:CheckShowNotificationFreeDeal()
    --- @param v IapShopRegularTabItem
    for typeTab, tab in pairs(self.tabDict:GetItems()) do
        tab:EnableNotify(ResourceMgr.GetPurchaseConfig():GetCashShop():IsNotificationFrequentlyDeal(typeTab))
    end
end