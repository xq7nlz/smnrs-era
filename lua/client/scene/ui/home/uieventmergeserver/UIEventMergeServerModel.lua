
--- @class UIEventMergeServerModel : UIBaseModel
UIEventMergeServerModel = Class(UIEventMergeServerModel, UIBaseModel)

--- @return void
function UIEventMergeServerModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventMergeServer, "ui_event_merge_server")

	self.listSubEvent = List()
end

--- @param eventTimeData EventTimeData
function UIEventMergeServerModel:InitListSubEvent(eventTimeData)
	self.listSubEvent = List()
	self.listSubEvent:Add(MergeServerTab.CHECK_IN)
	self.listSubEvent:Add(MergeServerTab.QUEST)
	self.listSubEvent:Add(MergeServerTab.EXCHANGE)
	self.listSubEvent:Add(MergeServerTab.BUNDLE)
	self.listSubEvent:Add(MergeServerTab.ACCUMULATION)
end