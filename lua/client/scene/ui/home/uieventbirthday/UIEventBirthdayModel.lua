
--- @class UIEventBirthdayModel : UIBaseModel
UIEventBirthdayModel = Class(UIEventBirthdayModel, UIBaseModel)

--- @return void
function UIEventBirthdayModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventBirthday, "ui_event_birthday")
end

function UIEventBirthdayModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(EventBirthdayTab.CHECK_IN)
	self.listSubEvent:Add(EventBirthdayTab.DARK_LIGHT)
	self.listSubEvent:Add(EventBirthdayTab.BUNDLE)
	self.listSubEvent:Add(EventBirthdayTab.EXCLUSIVE_BUNDLE)
	self.listSubEvent:Add(EventBirthdayTab.LEGACY_PATH)
	self.listSubEvent:Add(EventBirthdayTab.BOSS)
end