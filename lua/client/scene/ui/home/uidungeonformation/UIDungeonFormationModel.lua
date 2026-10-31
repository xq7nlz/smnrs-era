
--- @class UIDungeonFormationModel : UIBaseModel
UIDungeonFormationModel = Class(UIDungeonFormationModel, UIBaseModel)

--- @return void
function UIDungeonFormationModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDungeonFormation, "dungeon_formation")

	--- @type {}
	self.heroSelectedList = {}
end

