require "lua.client.scene.ui.home.uiStarterPackNew.UIStarterPackNewModel"
require "lua.client.scene.ui.home.uiStarterPackNew.UIStarterPackNewView"

--- @class UIStarterPackNew : UIBase
UIStarterPackNew = Class(UIStarterPackNew, UIBase)

--- @return void
function UIStarterPackNew:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIStarterPackNew:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIStarterPackNewModel()
	self.view = UIStarterPackNewView(self.model)
end

return UIStarterPackNew
