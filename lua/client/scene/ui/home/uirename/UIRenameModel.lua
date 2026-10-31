
--- @class UIRenameModel : UIBaseModel
UIRenameModel = Class(UIRenameModel, UIBaseModel)

--- @return void
function UIRenameModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIRename, "rename")

	self.bgDark = true
end

