
--- @class UISelectArenaModel : UIBaseModel
UISelectArenaModel = Class(UISelectArenaModel, UIBaseModel)

--- @return void
function UISelectArenaModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectArena, "ui_select_arena")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = true
end

