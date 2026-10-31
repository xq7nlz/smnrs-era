require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventSkinBundle1Layout : UIEventSkinBundleLayout
UIEventSkinBundle1Layout = Class(UIEventSkinBundle1Layout, UIEventSkinBundleLayout)

--- @param view UIEventSkinBundleView
--- @param uiEventSkinBundleTab UIEventSkinBundleTab
--- @param anchor UnityEngine_RectTransform
function UIEventSkinBundle1Layout:Ctor(view, uiEventSkinBundleTab, anchor)
    --- @type UIEventSkinBundle1LayoutConfig
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
    self.packViewType = PackViewType.EVENT_SKIN_BUNDLE_1
    --- @type ProductConfig
    self.specialProductConfig = nil
    --- @type IapSkinBundlePackItem
    self.iapSkinBundlePackItem = nil

    UIEventSkinBundleLayout.Ctor(self, view, uiEventSkinBundleTab, anchor)
end

function UIEventSkinBundle1Layout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_skin_bundle_1", self.anchor)
    UIEventSkinBundleLayout.InitLayoutConfig(self, inst)

    self.iapSkinBundlePackItem = IapSkinBundlePackItem(self.layoutConfig.iapSkinBundlePackItem)

    self:InitButtons()

    self:InitLocalization()

    self:InitScroll()
end

function UIEventSkinBundle1Layout:InitLocalization()
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("skin_bundle_1_desc")
end

function UIEventSkinBundle1Layout:InitButtons()

end

function UIEventSkinBundle1Layout:InitScroll()
    --- @param obj IapSkinBundlePackItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local index = index + 2
        --- @type ProductConfig
        local productConfig = self.packListScroll:Get(index)
        obj:SetIconData(productConfig)
    end
    self.uiLoopScroll = UILoopScroll(self.layoutConfig.loopScroll, UIPoolType.IapSkinBundlePackItem, onCreateItem)
end

function UIEventSkinBundle1Layout:OnShow()
    UIEventSkinBundleLayout.OnShow(self)

    self:GetListPack()

    self.specialProductConfig = self.packListScroll:Get(1)

    self:SetSpecialBundle()

    self.uiLoopScroll:Resize(self.packListScroll:Count() - 1)
end

function UIEventSkinBundle1Layout:SetSpecialBundle()
    self.iapSkinBundlePackItem:SetIconData(self.specialProductConfig)

    local listNonSkinItem = List()
    local rewardList = self.specialProductConfig:GetRewardList()
    for i = 1, rewardList:Count() do
        --- @type RewardInBound
        local rewardInBound = rewardList:Get(i)
        if rewardInBound.type ~= ResourceType.Skin then
            listNonSkinItem:Add(rewardInBound)
        end
    end

    self.iapSkinBundlePackItem:SetRewardList(listNonSkinItem)
end

function UIEventSkinBundle1Layout:OnHide()
    self.iapSkinBundlePackItem:OnHide()

    UIEventSkinBundleLayout.OnHide(self)

    self.uiLoopScroll:Hide()
end

function UIEventSkinBundle1Layout:GetListPack()
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
