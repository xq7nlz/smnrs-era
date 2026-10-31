require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"
require "lua.client.scene.ui.home.uiIapShop.eventBundleLarge.UIEventBundleLarge"

--- @class UIEventBirthdayBundleLayout : UIEventBirthdayLayout
UIEventBirthdayBundleLayout = Class(UIEventBirthdayBundleLayout, UIEventBirthdayLayout)

--- @param view UIEventBirthdayView
--- @param eventBirthdayTab EventBirthdayTab
--- @param anchor UnityEngine_RectTransform
function UIEventBirthdayBundleLayout:Ctor(view, eventBirthdayTab, anchor)
    --- @type UIEventBirthdayBundleLayoutConfig
    self.layoutConfig = nil
    --- @type EventBirthdayModel
    self.eventModel = nil
    --- @type PackOfProducts
    self.packOfProducts = nil
    --- @type OpCode
    self.opCode = OpCode.EVENT_BIRTHDAY_BUNDLE_PURCHASE
    --- @type List
    self.listBundleLarge = List()

    UIEventBirthdayLayout.Ctor(self, view, eventBirthdayTab, anchor)
end

function UIEventBirthdayBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_birthday_bundle", self.anchor)
    UIEventBirthdayLayout.InitLayoutConfig(self, inst)

    self.listBundleLarge:Add(UIEventBundleLarge(self.layoutConfig.bundle1))
    self.listBundleLarge:Add(UIEventBundleLarge(self.layoutConfig.bundle2))

    self:InitButtonListener()

    self:InitLocalization()
end

function UIEventBirthdayBundleLayout:InitLocalization()
    UIEventBirthdayLayout.InitLocalization(self)

    for i = 1, self.listBundleLarge:Count() do
        --- @type UIEventBundleLarge
        local eventBundleLarge = self.listBundleLarge:Get(i)
        eventBundleLarge:SetTittle(LanguageUtils.LocalizeCommon("event_birthday_bundle_" .. i))
    end
end

function UIEventBirthdayBundleLayout:InitButtonListener()

end

function UIEventBirthdayBundleLayout:GetModelConfig()
    UIEventBirthdayLayout.GetModelConfig(self)
end

function UIEventBirthdayBundleLayout:OnShow()
    UIEventBirthdayLayout.OnShow(self)

    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetBirthdayBundleStore():GetCurrentPack()
    for i = 1, self.listBundleLarge:Count() do
        local productConfig = self.packOfProducts:GetPackBase(i)
        --- @type UIEventBundleLarge
        local eventBundleLarge = self.listBundleLarge:Get(i)
        eventBundleLarge:SetProduct(productConfig, self.eventModel)

        eventBundleLarge:OnShow()
    end
end

function UIEventBirthdayBundleLayout:OnHide()
    UIEventBirthdayLayout.OnHide(self)

    for i = 1, self.listBundleLarge:Count() do
        --- @type UIEventBundleLarge
        local eventBundleLarge = self.listBundleLarge:Get(i)
        eventBundleLarge:OnHide()
    end
end