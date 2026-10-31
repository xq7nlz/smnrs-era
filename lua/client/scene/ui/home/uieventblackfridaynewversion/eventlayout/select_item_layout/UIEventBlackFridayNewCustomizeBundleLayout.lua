require("lua.client.scene.ui.home.uiEventBlackFridayNewVersion.eventLayout.UIEventBlackFridayNewVersionLayout")

--- @class UIEventBlackFridayNewCustomizeBundleLayout : UIEventBlackFridayNewVersionLayout
UIEventBlackFridayNewCustomizeBundleLayout = Class(UIEventBlackFridayNewCustomizeBundleLayout, UIEventBlackFridayNewVersionLayout)

--- @param view UIIapShopView
function UIEventBlackFridayNewCustomizeBundleLayout:Ctor(view, tab, anchor)
    --- @type List -- UICustomPackView
    self.packList = nil
    --- @type UIBlackFridayNewSelectItemConfig
    self.layoutConfig = nil
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    UIEventBlackFridayNewVersionLayout.Ctor(self, view, tab, anchor)
end

function UIEventBlackFridayNewCustomizeBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("black_friday_new_select_item", self.anchor)
    UIEventBlackFridayNewVersionLayout.InitLayoutConfig(self, inst)
    self:InitLocalization()
end

function UIEventBlackFridayNewCustomizeBundleLayout:InitLocalization()
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("title_black_friday_sale_select_item")
end

function UIEventBlackFridayNewCustomizeBundleLayout:InitPack()
    --- @param obj UIEventBlackFridayNewCustomPackView
    self.customPackView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIEventBlackFridayNewCustomPackView, self.layoutConfig.content)
    self.customPackView:SetData(self.listData:Get(1), self.view)
end

function UIEventBlackFridayNewCustomizeBundleLayout:OnShow()
    UIEventBlackFridayNewVersionLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetEventBlackFridayNewBundleStore():GetPack(self.eventModel.timeData.dataId).packDict
    self:InitLocalization()
    self:InitPack()
end