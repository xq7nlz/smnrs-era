require "lua.client.scene.ui.home.uiPreviewStarterPack.UIPreviewStarterPackModel"
require "lua.client.scene.ui.home.uiPreviewStarterPack.UIPreviewStarterPackView"

--- @class UIPreviewStarterPack : UIBase
UIPreviewStarterPack = Class(UIPreviewStarterPack, UIBase)

--- @return void
function UIPreviewStarterPack:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPreviewStarterPack:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPreviewStarterPackModel()
	self.view = UIPreviewStarterPackView(self.model)
end

return UIPreviewStarterPack
