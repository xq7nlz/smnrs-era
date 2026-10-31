require "lua.client.scene.ui.home.uiEventBlackFriday.uiEventBlackFridayLayout.Bundle.UIBlackFridayBundlePackView"

--- @class UIBlackFridayBundleLayout : UIIapShopLayout
UIBlackFridayBundleLayout = Class(UIBlackFridayBundleLayout, UIEventBlackFridayLayout)

--- @param view UIIapShopView
------ @param blackFridayTab BlackFridayTab
function UIBlackFridayBundleLayout:Ctor(view, blackFridayTab, anchor)
    ---@type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBlackFridayBundlePackView
    ---@type BlackFridayTab
    self.blackFridayTab = blackFridayTab
    self.packList = nil
    ---@type BlackFridayTab
    self.blackFridayTab = blackFridayTab
    --- @type UIBlackFridayBundleLayoutConfig
    self.layoutConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_BLACK_FRIDAY)
    --UIEventBlackFridayLayout.Ctor(self, view,  EventTimeType.EVENT_BLACK_FRIDAY, anchor)
    self:InitLayoutConfig()
end

function UIBlackFridayBundleLayout:OnShow()
    local eventBlackFridayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY)
    UIEventBlackFridayLayout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UIBlackFridayBundlePackView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventBlackFridayModel.timeData.dataId)
    end
end

function UIBlackFridayBundleLayout:OnHide()
    UIEventBlackFridayLayout.OnHide(self)
end

function UIBlackFridayBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("black_friday_bundle_layout", self.anchor)
    UIEventBlackFridayLayout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
end

function UIBlackFridayBundleLayout:InitPacks()
    self.packList = List()
    for i = 1, self.layoutConfig.rectTrans:GetChild(0).childCount do
        ---@type UIBlackFridayBundlePackView
        local packView = UIBlackFridayBundlePackView(self.layoutConfig.rectTrans:GetChild(0):GetChild(i - 1))
        self.packList:Add(packView)
    end
end

function UIBlackFridayBundleLayout:InitButtons()
end

function UIBlackFridayBundleLayout:InitLocalization()
end