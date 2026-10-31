--- @class UIEventTowerOfEitriModel : UIBaseModel
UIEventTowerOfEitriModel = Class(UIEventTowerOfEitriModel, UIBaseModel)

--- @return void
function UIEventTowerOfEitriModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventTowerOfEitri, "ui_event_tower_of_eitri")

	self.listSubEvent = List()
	self.listSubEvent:Add(EventTowerOfEitriTab.TOWER_BUILD)
	self.listSubEvent:Add(EventTowerOfEitriTab.TOWER_EXCHANGE)
	self.listSubEvent:Add(EventTowerOfEitriTab.TOWER_BUNDLE)
	self.listSubEvent:Add(EventTowerOfEitriTab.TOWER_QUEST)
end