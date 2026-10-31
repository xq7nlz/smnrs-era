require "lua.client.scene.ui.home.uiEventChristmas.UIEventChristmasModel"
require "lua.client.scene.ui.home.uiEventChristmas.UIEventChristmasView"

--- @class UIEventChristmas : UIBase
UIEventChristmas = Class(UIEventChristmas, UIBase)

--- @return void
function UIEventChristmas:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventChristmas:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventChristmasModel()
	self.view = UIEventChristmasView(self.model)
end

return UIEventChristmas
