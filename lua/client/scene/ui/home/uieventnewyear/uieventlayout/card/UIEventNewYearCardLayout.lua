require "lua.client.scene.ui.home.uiEventNewYear.uiEventLayout.card.UICardNewYearView"

--- @class UIEventNewYearCardLayout : UIEventNewYearLayout
UIEventNewYearCardLayout = Class(UIEventNewYearCardLayout, UIEventNewYearLayout)

--- @param view UIEventNewYearView
function UIEventNewYearCardLayout:Ctor(view, tab, anchor)
    self.anchor = anchor
    self.tab = tab
    ---@type NewYearCardConfig
    self.layoutConfig = nil
    UIEventNewYearLayout.Ctor(self, view, tab, anchor)
end

--- @param objectView UnityEngine_GameObject
function UIEventNewYearCardLayout:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("new_year_card_layout", self.anchor)
    UIEventNewYearLayout.InitLayoutConfig(self, inst)
    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)

    self.opCode = OpCode.EVENT_NEW_YEAR_CARD_PURCHASE

    self.actionType = EventActionType.NEW_YEAR_CARD_BUNDLE_PURCHASE

    self:InitButtons()
    self:InitPacks()
    self:InitLocalization()
end

function UIEventNewYearCardLayout:SetUpLayout()
    UIEventNewYearLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventNewYearCardLayout:OnShow()
    UIEventNewYearLayout.OnShow(self)
    self.packView:OnShow(1, self.eventModel.timeData.dataId)

    zg.playerData.remoteConfig.lastTimeCheckOutNewYearCard = zg.timeMgr:GetServerTime()
    zg.playerData:SaveRemoteConfig()
    self.view:UpdateNotificationByTab(NewYearTab.CARD)
end

function UIEventNewYearCardLayout:InitPacks()
    self.packView = UICardNewYearView(self.layoutConfig.packAnchor, self)
end

function UIEventNewYearCardLayout:InitButtons()
end

function UIEventNewYearCardLayout:InitLocalization()
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("new_year_card_title")
    self.packView:InitLocalization()
end

function UIEventNewYearCardLayout:OnHide()
    self.packView:OnHide()
end