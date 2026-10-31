require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventSkinBundle2Layout : UIEventSkinBundleLayout
UIEventSkinBundle2Layout = Class(UIEventSkinBundle2Layout, UIEventSkinBundleLayout)

--- @param view UIEventSkinBundleView
--- @param uiEventSkinBundleTab UIEventSkinBundleTab
--- @param anchor UnityEngine_RectTransform
function UIEventSkinBundle2Layout:Ctor(view, uiEventSkinBundleTab, anchor)
    --- @type UIEventSkinBundle2LayoutConfig
    self.layoutConfig = nil
    --- @type PackOfProducts
    self.packOfProducts = nil
    --- @type UILoopScroll
    self.uiLoopScroll = nil
    --- @type EventSkinBundleModel
    self.eventModel = nil
    --- @type List
    self.packListScroll = nil
    --- @type PackViewType
    self.packViewType = PackViewType.EVENT_SKIN_BUNDLE_2

    UIEventSkinBundleLayout.Ctor(self, view, uiEventSkinBundleTab, anchor)
end

function UIEventSkinBundle2Layout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_skin_bundle_2", self.anchor)
    UIEventSkinBundleLayout.InitLayoutConfig(self, inst)

    self:InitButtons()

    self:InitLocalization()

    self:InitScroll()
end

function UIEventSkinBundle2Layout:InitButtons()

end

function UIEventSkinBundle2Layout:InitScroll()
    --- @param obj IapSkinBundlePackItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local index = index + 1
        --- @type ProductConfig
        local productConfig = self.packListScroll:Get(index)
        obj:SetIconData(productConfig)
    end
    self.uiLoopScroll = UILoopScroll(self.layoutConfig.loopScroll, UIPoolType.IapSkinBundlePackItem, onCreateItem)
end

function UIEventSkinBundle2Layout:OnShow()
    UIEventSkinBundleLayout.OnShow(self)

    self:GetListPack()

    self.uiLoopScroll:Resize(self.packListScroll:Count())
end

function UIEventSkinBundle2Layout:OnHide()
    UIEventSkinBundleLayout.OnHide(self)

    self.uiLoopScroll:Hide()
end

function UIEventSkinBundle2Layout:GetListPack()
    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetSkinBundleStore():GetCurrentPack()
    local listPack = self.packOfProducts:GetAllPackBase()

    self.packListScroll = List()
    for i = 1, listPack:Count() do
        --- @type ProductConfig
        local productConfig = listPack:Get(i)
        if productConfig.viewType == self.packViewType then
            self.packListScroll:Add(productConfig)
        end
    end
end
