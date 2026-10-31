require "lua.client.scene.ui.home.uiEventHeroBoss.UIEventHeroBossModel"
require "lua.client.scene.ui.home.uiEventHeroBoss.UIEventHeroBossView"

--- @class UIEventHeroBoss : UIBase
UIEventHeroBoss = Class(UIEventHeroBoss, UIBase)

--- @return void
function UIEventHeroBoss:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventHeroBoss:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventHeroBossModel()
	self.view = UIEventHeroBossView(self.model)
end

return UIEventHeroBoss
