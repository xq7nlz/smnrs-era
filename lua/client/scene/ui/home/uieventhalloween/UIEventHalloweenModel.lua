require "lua.client.core.network.event.eventHalloweenModel.EventHalloweenModel"
--- @class UIEventHalloweenModel : UIBaseModel
UIEventHalloweenModel = Class(UIEventHalloweenModel, UIBaseModel)

--- @return void
function UIEventHalloweenModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIEventHalloween, "ui_event_halloween")

    self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventHalloweenModel:InitListSubEvent(eventTimeData)
    self.listSubEvent = List()
    self.listSubEvent:Add(HalloweenTab.GOLDEN_TIME)
    self.listSubEvent:Add(HalloweenTab.DICE)
    self.listSubEvent:Add(HalloweenTab.QUEST)
    self.listSubEvent:Add(HalloweenTab.EXCHANGE)
    if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 10 then
        self.listSubEvent:Add(HalloweenTab.SPECIAL_OFFER)
    end
    --self.listSubEvent:Add(HalloweenTab.DAILY_CHECK_IN)
    self.listSubEvent:Add(HalloweenTab.SHOP)
end

