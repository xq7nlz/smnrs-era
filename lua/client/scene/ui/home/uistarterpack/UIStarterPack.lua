require "lua.client.scene.ui.home.uiStarterPack.UIStarterPackModel"
require "lua.client.scene.ui.home.uiStarterPack.UIStarterPackView"

--- @class UIStarterPack : UIBase
UIStarterPack = Class(UIStarterPack, UIBase)

--- @return void
function UIStarterPack:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIStarterPack:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIStarterPackModel()
	self.view = UIStarterPackView(self.model)
end

return UIStarterPack
