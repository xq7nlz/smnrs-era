require "lua.client.scene.ui.instant.uiNewUpdate.UINewUpdateModel"
require "lua.client.scene.ui.instant.uiNewUpdate.UINewUpdateView"
require "lua.client.scene.ui.instant.uiNewUpdate.UINewUpdateCtrl"

--- @class UINewUpdate : UIBase
UINewUpdate = Class(UINewUpdate, UIBase)

--- @return void
function UINewUpdate:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UINewUpdate:OnCreate()
	UIBase.OnCreate(self)
	self.model = UINewUpdateModel()
	self.ctrl = UINewUpdateCtrl(self.model)
	self.view = UINewUpdateView(self.model, self.ctrl)
end

return UINewUpdate
