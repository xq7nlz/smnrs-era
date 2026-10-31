
--- @class UIEventAiryuuModel : UIBaseModel
UIEventAiryuuModel = Class(UIEventAiryuuModel, UIBaseModel)

--- @return void
function UIEventAiryuuModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventAiryuu, "ui_event_airyuu")

	self.listSubEvent = List()
	self.listSubEvent:Add(EventAiryuuTab.CHECK_IN)
	self.listSubEvent:Add(EventAiryuuTab.HERO_TREASURE)
	self.listSubEvent:Add(EventAiryuuTab.HERO_QUEST)
	self.listSubEvent:Add(EventAiryuuTab.HERO_BUNDLE)
	self.listSubEvent:Add(EventAiryuuTab.HERO_COLLECTION)
	self.listSubEvent:Add(EventAiryuuTab.HERO_TRIAL)
end