require "lua.client.scene.ui.home.uiEventBlackFriday.uiEventBlackFridayLayout.EventCard.UICardBlackFridayItemView"
--- @class UICardLayout : UIEventBlackFridayLayout
UICardLayout = Class(UICardLayout, UIEventBlackFridayLayout)

--- @param view UIEventBlackFridayView
--- @param blackFridayTab BlackFridayTab
--- @param anchor UnityEngine_RectTransform
function UICardLayout:Ctor(view, blackFridayTab, anchor)
    self.anchor = anchor
    self.blackFridayTab = blackFridayTab
    ---@type BlackFridayCardLayoutConfig
    self.layoutConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_BLACK_FRIDAY)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UICardLayout:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("black_friday_card_layout", self.anchor)
    UIEventBlackFridayLayout.InitLayoutConfig(self, inst)
    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitPacks()
    self:InitLocalization()
end

function UICardLayout:SetUpLayout()
    UIEventBlackFridayLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UICardLayout:OnShow()
    UIEventBlackFridayLayout.OnShow(self)
    self.packView:OnShow(1, self.eventBlackFriday.timeData.dataId)
end
function UICardLayout:InitPacks()
    self.eventBlackFriday = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY)
    self.packView = UICardBlackFridayItemView(self.layoutConfig.packAnchor, self)
end


function UICardLayout:InitButtons()
end

function UICardLayout:InitLocalization()
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("black_friday_card")
    self.packView:InitLocalization()
end

function UICardLayout:OnHide()
    self.packView:Hide()
end