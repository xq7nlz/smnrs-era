
--- @class UIEventLunarNewYearModel : UIBaseModel
UIEventLunarNewYearModel = Class(UIEventLunarNewYearModel, UIBaseModel)

--- @return void
function UIEventLunarNewYearModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventLunarNewYear, "ui_event_lunar_new_year")
end

function UIEventLunarNewYearModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(LunarNewYearTab.CHECK_IN)
	self.listSubEvent:Add(LunarNewYearTab.SPRING_BOX)
	self.listSubEvent:Add(LunarNewYearTab.LION_DANCE)
	self.listSubEvent:Add(LunarNewYearTab.SPRING_BUNDLE)
	self.listSubEvent:Add(LunarNewYearTab.LUNAR_BUNDLE)
	self.listSubEvent:Add(LunarNewYearTab.TIGER_PATH)
end