require "lua.client.scene.ui.home.uiHandOfMidas.UIHandOfMidasModel"
require "lua.client.scene.ui.home.uiHandOfMidas.UIHandOfMidasView"

--- @class UIHandOfMidas : UIBase
UIHandOfMidas = Class(UIHandOfMidas, UIBase)

--- @return void
function UIHandOfMidas:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIHandOfMidas:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIHandOfMidasModel()
	self.view = UIHandOfMidasView(self.model, self.ctrl)
end

return UIHandOfMidas
