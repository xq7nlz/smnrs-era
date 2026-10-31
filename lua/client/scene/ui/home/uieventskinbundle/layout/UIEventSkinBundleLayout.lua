--- @class UIEventSkinBundleLayout
UIEventSkinBundleLayout = Class(UIEventSkinBundleLayout)

--- @param view UIEventSkinBundleView
--- @param tab UIEventSkinBundleTab
--- @param anchor UnityEngine_RectTransform
function UIEventSkinBundleLayout:Ctor(view, tab, anchor)
    --- @type UIEventSkinBundleView
    self.view = view
    --- @type UIEventSkinBundleTab
    self.tab = tab
    --- @type UnityEngine_Transform
    self.anchor = anchor

    --- @type UILoopScroll
    self.uiScroll = self.view.uiScroll
    --- @type UIEventSkinBundleConfig
    self.config = view.config

    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventSkinBundleLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventSkinBundleLayout:_InitConfig()

end

function UIEventSkinBundleLayout:OnShow()
    self:SetUpLayout()
end

function UIEventSkinBundleLayout:SetUpLayout()
    self.anchor.gameObject:SetActive(true)
end

function UIEventSkinBundleLayout:OnHide()
    self.anchor.gameObject:SetActive(false)
end

function UIEventSkinBundleLayout:OnClaimSuccess()

end

function UIEventSkinBundleLayout:InitLocalization()

end