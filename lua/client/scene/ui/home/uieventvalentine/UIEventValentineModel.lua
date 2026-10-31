
--- @class UIEventValentineModel : UIBaseModel
UIEventValentineModel = Class(UIEventValentineModel, UIBaseModel)

--- @return void
function UIEventValentineModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventValentine, "ui_event_valentine")
end

function UIEventValentineModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(ValentineTab.CHECK_IN)
	self.listSubEvent:Add(ValentineTab.LOVE_CHALLENGE)
	self.listSubEvent:Add(ValentineTab.LOVE_BUNDLE)
	self.listSubEvent:Add(ValentineTab.OPEN_CARD)
end