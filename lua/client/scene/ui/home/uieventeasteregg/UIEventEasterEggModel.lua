
--- @class UIEventEasterEggModel : UIBaseModel
UIEventEasterEggModel = Class(UIEventEasterEggModel, UIBaseModel)

--- @return void
function UIEventEasterEggModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventEasterEgg, "ui_event_easter_egg")

	self.listSubEvent = List()
end

function UIEventEasterEggModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(EasterEggTab.CHECK_IN)
	self.listSubEvent:Add(EasterEggTab.DICE)
	self.listSubEvent:Add(EasterEggTab.EXCLUSIVE_BUNDLE)
	self.listSubEvent:Add(EasterEggTab.BREAK)
	self.listSubEvent:Add(EasterEggTab.EASTER_BUNDLE)
end