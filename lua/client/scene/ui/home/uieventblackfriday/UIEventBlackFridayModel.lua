require "lua.client.core.network.event.eventBlackFridayModel.EventBlackFridayModel"
--- @class UIEventBlackFridayModel: UIBaseModel
UIEventBlackFridayModel = Class(UIEventBlackFridayModel, UIBaseModel)

--- @return void
function UIEventBlackFridayModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIEventBlackFriday, "ui_event_black_friday")
    self.type = UIPopupType.NORMAL_POPUP
    self.bgDark = true
    self.listSubEvent = List()
end

function UIEventBlackFridayModel:InitListSubEvent()
    self.listSubEvent = List()
    self.listSubEvent:Add(BlackFridayTab.CARD)
    self.listSubEvent:Add(BlackFridayTab.GEM_BOX)
    self.listSubEvent:Add(BlackFridayTab.DAILY_CHECK_IN)
end

