
--- @class UIDungeonBuffModel : UIBaseModel
UIDungeonBuffModel = Class(UIDungeonBuffModel, UIBaseModel)

--- @return void
function UIDungeonBuffModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDungeonBuff, "dungeon_buff")

	self.bgDark = true
end

