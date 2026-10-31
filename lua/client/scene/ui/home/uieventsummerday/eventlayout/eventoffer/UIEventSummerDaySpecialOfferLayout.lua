require "lua.client.scene.ui.home.uiEventSummerDay.EventLayout.EventOffer.UISpecialOfferSummerDayItemView"

--- @class UIEventSummerDaySpecialOfferLayout : UIEventSummerDayLayout
UIEventSummerDaySpecialOfferLayout = Class(UIEventSummerDaySpecialOfferLayout, UIEventSummerDayLayout)

--- @param view UIEventView
function UIEventSummerDaySpecialOfferLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventSummerDayModel
    self.eventModel = nil
    --- @type EventSummerDayConfig
    self.eventConfig = nil
    --- @type UISpecialOfferMidAutumnConfig
    self.layoutConfig = nil
    --- @type UISpecialOfferSummerDayItemView
    self.packList = nil

    UIEventSummerDayLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventSummerDaySpecialOfferLayout:OnShow()
    UIEventSummerDayLayout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UISpecialOfferSummerDayItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventModel.timeData.dataId)
    end
end

function UIEventSummerDaySpecialOfferLayout:OnHide()
    UIEventSummerDayLayout.OnHide(self)
end

function UIEventSummerDaySpecialOfferLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("summer_day_special_offer", self.anchor)
    UIEventSummerDayLayout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
end

function UIEventSummerDaySpecialOfferLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SUMMER_DAY)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UISpecialOfferSummerDayItemView(self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end


function UIEventSummerDaySpecialOfferLayout:InitButtons()
end

function UIEventSummerDaySpecialOfferLayout:InitLocalization()
end

