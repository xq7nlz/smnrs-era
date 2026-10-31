require "lua.client.scene.ui.home.uiEventEasterDay.EventLayout.EventSpecialOffer.UISpecialOfferEasterDayItemView"

--- @class UIEventEasterDaySpecialOfferLayout : UIEventEasterDayLayout
UIEventEasterDaySpecialOfferLayout = Class(UIEventEasterDaySpecialOfferLayout, UIEventEasterDayLayout)

--- @param view UIEventView
function UIEventEasterDaySpecialOfferLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventEasterDayModel
    self.eventModel = nil
    --- @type EventEasterDayConfig
    self.eventConfig = nil
    --- @type UISpecialOfferMidAutumnConfig
    self.layoutConfig = nil
    --- @type UISpecialOfferThanksGivingItemView
    self.packList = nil

    UIEventEasterDayLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventEasterDaySpecialOfferLayout:OnShow()
    UIEventEasterDayLayout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UISpecialOfferThanksGivingItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventModel.timeData.dataId)
    end
end

function UIEventEasterDaySpecialOfferLayout:OnHide()
    UIEventEasterDayLayout.OnHide(self)
end

function UIEventEasterDaySpecialOfferLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("easter_day_special_offer", self.anchor)
    UIEventEasterDayLayout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitButtons()
    self:InitLocalization()
    self:InitPacks()
end

function UIEventEasterDaySpecialOfferLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_DAY)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UISpecialOfferEasterDayItemView(self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end


function UIEventEasterDaySpecialOfferLayout:InitButtons()
end

function UIEventEasterDaySpecialOfferLayout:InitLocalization()
end

