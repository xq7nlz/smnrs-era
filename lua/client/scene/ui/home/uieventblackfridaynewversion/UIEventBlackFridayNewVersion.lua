require "lua.client.scene.ui.home.uiEventBlackFridayNewVersion.UIEventBlackFridayNewVersionModel"
require "lua.client.scene.ui.home.uiEventBlackFridayNewVersion.UIEventBlackFridayNewVersionView"

--- @class UIEventBlackFridayNewVersion : UIBase
UIEventBlackFridayNewVersion = Class(UIEventBlackFridayNewVersion, UIBase)

--- @return void
function UIEventBlackFridayNewVersion:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventBlackFridayNewVersion:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventBlackFridayNewVersionModel()
	self.view = UIEventBlackFridayNewVersionView(self.model)
end

return UIEventBlackFridayNewVersion
