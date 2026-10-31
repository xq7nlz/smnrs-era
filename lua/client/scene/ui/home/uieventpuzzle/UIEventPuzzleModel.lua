
--- @class UIEventPuzzleModel : UIBaseModel
UIEventPuzzleModel = Class(UIEventPuzzleModel, UIBaseModel)

--- @return void
function UIEventPuzzleModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventPuzzle, "ui_event_puzzle")

	self.listSubEvent = List()
end

function UIEventPuzzleModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(EventPuzzleTab.SELECT_HERO)
	self.listSubEvent:Add(EventPuzzleTab.PUZZLE)
end