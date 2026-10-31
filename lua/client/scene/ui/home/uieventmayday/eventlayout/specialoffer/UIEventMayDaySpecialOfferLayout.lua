require "lua.client.scene.ui.home.uiEventMayDay.EventLayout.specialOffer.UISpecialOfferMayDayItemView"

--- @class UIEventMayDaySpecialOfferLayout : UIEventMayDayLayout
UIEventMayDaySpecialOfferLayout = Class(UIEventMayDaySpecialOfferLayout, UIEventMayDayLayout)

--- @param view UIEventView
function UIEventMayDaySpecialOfferLayout:Ctor(view, midAutumnTab, anchor)
    --- @type UISpecialOfferMayDayConfig
    self.layoutConfig = nil
    --- @type UISpecialOfferMayDayItemView
    self.packList = nil

    UIEventMayDayLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventMayDaySpecialOfferLayout:OnShow()
    UIEventMayDayLayout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UISpecialOfferMayDayItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventModel.timeData.dataId)
    end
end

function UIEventMayDaySpecialOfferLayout:OnHide()
    UIEventMayDayLayout.OnHide(self)
end

function UIEventMayDaySpecialOfferLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("may_day_special_offer", self.anchor)
    UIEventMayDayLayout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
end

function UIEventMayDaySpecialOfferLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MAY_DAY)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UISpecialOfferMayDayItemView(self.view, self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end


function UIEventMayDaySpecialOfferLayout:InitButtons()
end

function UIEventMayDaySpecialOfferLayout:InitLocalization()
end

