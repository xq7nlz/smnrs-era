require "lua.client.core.network.event.eventXmasModel.EventXmasModel"
--- @class UIEventXmasModel : UIBaseModel
UIEventXmasModel = Class(UIEventXmasModel, UIBaseModel)

--- @return void
function UIEventXmasModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIEventXmas, "ui_event_xmas")

    self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventXmasModel:InitListSubEvent(eventTimeData)
    self.listSubEvent = List()
    self.listSubEvent:Add(XmasTab.GOLDEN_TIME)
    self.listSubEvent:Add(XmasTab.FROSTY_IGNATIUS)
    self.listSubEvent:Add(XmasTab.SHOP)
    if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 10 then
        self.listSubEvent:Add(XmasTab.EXCLUSIVE_OFFER)
    end
    self.listSubEvent:Add(XmasTab.DAILY_CHECK_IN)
end

