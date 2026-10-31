require "lua.client.scene.ui.home.uiMail.UIMailModel"
require "lua.client.scene.ui.home.uiMail.UIMailView"

--- @class UIMail : UIBase
UIMail = Class(UIMail, UIBase)

--- @return void
function UIMail:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIMail:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIMailModel()
	self.view = UIMailView(self.model, self.ctrl)
end

return UIMail
