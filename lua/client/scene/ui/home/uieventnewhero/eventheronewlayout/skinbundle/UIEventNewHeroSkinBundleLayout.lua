require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"
require "lua.client.scene.ui.home.uiIapShop.eventBundleLarge.UIEventBundleLarge"

--- @class UIEventNewHeroSkinBundleLayout : UIEventNewHeroLayout
UIEventNewHeroSkinBundleLayout = Class(UIEventNewHeroSkinBundleLayout, UIEventNewHeroLayout)

--- @param view UIEventNewHeroView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventNewHeroSkinBundleLayout:Ctor(view, eventTimeType, anchor)
    --- @type UIEventNewHeroSkinBundleLayoutConfig
    self.layoutConfig = nil
    --- @type PackOfProducts
    self.packOfProducts = nil
    --- @type EventNewHeroBundleModel
    self.eventModel = nil
    --- @type OpCode
    self.opCode = OpCode.EVENT_BIRTHDAY_BUNDLE_PURCHASE
    --- @type List
    self.listBundleLarge = List()

    UIEventNewHeroLayout.Ctor(self, view, eventTimeType, anchor)
end

function UIEventNewHeroSkinBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_new_hero_skin_bundle", self.anchor)
    UIEventNewHeroLayout.InitLayoutConfig(self, inst)

    self.listBundleLarge:Add(UIEventBundleLarge(self.layoutConfig.eventBundleLarge1))
    self.listBundleLarge:Add(UIEventBundleLarge(self.layoutConfig.eventBundleLarge2))

    self:InitLocalization()
end

function UIEventNewHeroSkinBundleLayout:InitLocalization()
    UIEventNewHeroLayout.InitLocalization(self)

    if self.eventModel ~= nil then
        for i = 1, self.listBundleLarge:Count() do
            --- @type UIEventBundleLarge
            local eventBundleLarge = self.listBundleLarge:Get(i)
            local title = LanguageUtils.LocalizeCommon("event_new_hero_skin_bundle_" .. i .. "_data_" .. self.eventModel.timeData.dataId)
            eventBundleLarge:SetTittle(title)
        end
    end
end

function UIEventNewHeroSkinBundleLayout:OnShow()
    UIEventNewHeroLayout.OnShow(self)

    self:InitLocalization()

    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetNewHeroSkinBundleStore():GetCurrentPack()
    for i = 1, self.listBundleLarge:Count() do
        local productConfig = self.packOfProducts:GetPackBase(i)
        --- @type UIEventBundleLarge
        local eventBundleLarge = self.listBundleLarge:Get(i)
        eventBundleLarge:SetProduct(productConfig, self.eventModel)

        eventBundleLarge:OnShow()
    end
end

function UIEventNewHeroSkinBundleLayout:OnHide()
    UIEventNewHeroLayout.OnHide(self)

    for i = 1, self.listBundleLarge:Count() do
        --- @type UIEventBundleLarge
        local eventBundleLarge = self.listBundleLarge:Get(i)
        eventBundleLarge:OnHide()
    end
end