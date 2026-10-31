require "lua.client.scene.ui.home.uiTempleReplace.UITempleReplaceModel"
require "lua.client.scene.ui.home.uiTempleReplace.UITempleReplaceView"
require "lua.client.scene.ui.home.uiTempleReplace.UITempleReplaceCtrl"

--- @class UITempleReplace : UIBase
UITempleReplace = Class(UITempleReplace, UIBase)

--- @return void
function UITempleReplace:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UITempleReplace:OnCreate()
	UIBase.OnCreate(self)
	self.model = UITempleReplaceModel()
	self.ctrl = UITempleReplaceCtrl(self.model)
	self.view = UITempleReplaceView(self.model, self.ctrl)
end

return UITempleReplace
