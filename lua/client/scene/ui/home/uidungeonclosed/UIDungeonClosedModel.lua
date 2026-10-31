
--- @class UIDungeonClosedModel : UIBaseModel
UIDungeonClosedModel = Class(UIDungeonClosedModel, UIBaseModel)

--- @return void
function UIDungeonClosedModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDungeonClosed, "dungeon_closed")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
end

