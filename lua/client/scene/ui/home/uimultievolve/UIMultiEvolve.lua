require "lua.client.scene.ui.home.uiMultiEvolve.UIMultiEvolveModel"
require "lua.client.scene.ui.home.uiMultiEvolve.UIMultiEvolveView"

--- @class UIMultiEvolve : UIBase
UIMultiEvolve = Class(UIMultiEvolve, UIBase)

--- @return void
function UIMultiEvolve:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIMultiEvolve:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIMultiEvolveModel()
	self.view = UIMultiEvolveView(self.model)
end

return UIMultiEvolve
