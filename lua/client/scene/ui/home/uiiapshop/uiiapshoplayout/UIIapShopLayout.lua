--- @class UIIapShopLayout
UIIapShopLayout = Class(UIIapShopLayout)

--- @param view UIIapShopView
--- @param parent UnityEngine_RectTransform
function UIIapShopLayout:Ctor(view, parent)
    --- @type UIIapShopView
    self.view = view
    --- @type UIIapShopConfig
    self.config = view.config
    self:InitLayoutConfig(parent)
end

--- @param parent UnityEngine_RectTransform
function UIIapShopLayout:InitLayoutConfig(parent)

end

function UIIapShopLayout:InitLocalization()

end

--- @param iapShopTab IapShopTab
function UIIapShopLayout:OnShow(iapShopTab)
    self:SetUpLayout()
end

function UIIapShopLayout:SetUpLayout()

end

function UIIapShopLayout:OnHide()

end

function UIIapShopLayout:OnDestroy()

end