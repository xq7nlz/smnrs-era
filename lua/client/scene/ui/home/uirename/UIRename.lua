require "lua.client.scene.ui.home.uiRename.UIRenameModel"
require "lua.client.scene.ui.home.uiRename.UIRenameView"

--- @class UIRename : UIBase
UIRename = Class(UIRename, UIBase)

--- @return void
function UIRename:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIRename:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIRenameModel()
	self.view = UIRenameView(self.model, self.ctrl)
end

return UIRename
