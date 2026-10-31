require "lua.client.core.network.event.eventNewYear.EventNewYearModel"
--- @class UIEventNewYearModel : UIBaseModel
UIEventNewYearModel = Class(UIEventNewYearModel, UIBaseModel)

--- @return void
function UIEventNewYearModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIEventNewYear, "ui_event_new_year")

    self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventNewYearModel:InitListSubEvent(eventTimeData)
    self.listSubEvent = List()
    self.listSubEvent:Add(NewYearTab.GOLDEN_TIME)
    self.listSubEvent:Add(NewYearTab.CARD)
    self.listSubEvent:Add(NewYearTab.LOTTERY)
    self.listSubEvent:Add(NewYearTab.EXCHANGE)
    self.listSubEvent:Add(NewYearTab.BUNDLE)
end

