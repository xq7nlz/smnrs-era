
--- @class UIEventZodiacModel : UIBaseModel
UIEventZodiacModel = Class(UIEventZodiacModel, UIBaseModel)

--- @return void
function UIEventZodiacModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventZodiac, "ui_event_zodiac")
end

function UIEventZodiacModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(EventZodiacTab.CONSTELLATIONS)
	self.listSubEvent:Add(EventZodiacTab.EXCHANGE)
	self.listSubEvent:Add(EventZodiacTab.QUEST)
	self.listSubEvent:Add(EventZodiacTab.BUNDLE)
end