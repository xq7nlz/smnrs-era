require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopMonthlyCardLayout.UISubscriptionPackView"

--- @class UIIapShopMonthlyCardLayout : UIIapShopLayout
UIIapShopMonthlyCardLayout = Class(UIIapShopMonthlyCardLayout, UIIapShopLayout)

--- @param view UIIapShopView
function UIIapShopMonthlyCardLayout:Ctor(view, parent)
    --- @type UISubscriptionPackView
    self.packList = nil
    --- @type UIIapShopMonthlyCardLayoutConfig
    self.layoutConfig = nil
    UIIapShopLayout.Ctor(self, view, parent)
end

--- @param parent UnityEngine_RectTransform
function UIIapShopMonthlyCardLayout:InitLayoutConfig(parent)
    local inst = PrefabLoadUtils.Instantiate("monthly_card_view", parent)
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(inst.transform, parent)
    inst:SetActive(true)

    self:InitPack()
end

function UIIapShopMonthlyCardLayout:InitLocalization()
    self.layoutConfig.textHotDeal.text = LanguageUtils.LocalizeCommon("hot_deal")
end

function UIIapShopMonthlyCardLayout:InitPack()
    self.packList = List()
    for i = 2, self.layoutConfig.content.childCount do
        local packView = UISubscriptionPackView(self.layoutConfig.content:GetChild(i - 1), i)
        self.packList:Add(packView)
    end
end

--- @param iapShopTab IapShopTab
function UIIapShopMonthlyCardLayout:OnShow(iapShopTab)
    self.config.monthlyCardView.gameObject:SetActive(true)
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "monthly_card")
    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    for i = 1, self.packList:Count() do
        --- @type UISubscriptionPackView
        local pack = self.packList:Get(i)
        pack.config.gameObject:SetActive(true)
        pack:ShowPack()
        if pack.packId == 3 or pack.packId == 4 then
            local trialDuration = self.iapDataInBound:GetTrialDurationSubscription(pack.packId)
            local duration = self.iapDataInBound:GetDurationInSubscriptionPack(pack.packId)

            if trialDuration == nil then
                trialDuration = 0
            end
            if duration == nil then
                duration = 0
            end

            if duration + trialDuration <= 0 then
                pack.config.gameObject:SetActive(false)
            end
        end
    end

    if self.packList:Count() > 3 then
        self.layoutConfig.scrollHorizontal.horizontal = true
    else
        self.layoutConfig.scrollHorizontal.horizontal = false
    end
    self.isShowing = true
end

function UIIapShopMonthlyCardLayout:OnHide()
    self.isShowing = false
    for i = 1, self.packList:Count() do
        local pack = self.packList:Get(i)
        pack:Hide()
    end
end