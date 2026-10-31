
--- @class UIEventKazetsuModel : UIBaseModel
UIEventKazetsuModel = Class(UIEventKazetsuModel, UIBaseModel)

--- @return void
function UIEventKazetsuModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventKazetsu, "ui_event_kazetsu")
end

function UIEventKazetsuModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(EventKazetsuTab.CHECK_IN)
	self.listSubEvent:Add(EventKazetsuTab.BUNDLE)
	self.listSubEvent:Add(EventKazetsuTab.GIFT)
	self.listSubEvent:Add(EventKazetsuTab.BOSS)
	self.listSubEvent:Add(EventKazetsuTab.TRIAL)
end