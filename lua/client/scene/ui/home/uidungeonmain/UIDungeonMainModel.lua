
--- @class UIDungeonMainModel : UIBaseModel
UIDungeonMainModel = Class(UIDungeonMainModel, UIBaseModel)

--- @return void
function UIDungeonMainModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDungeonMain, "dungeon_main")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
end

