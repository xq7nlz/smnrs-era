require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggModel"
require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggView"

--- @class UIEventEasterEgg : UIBase
UIEventEasterEgg = Class(UIEventEasterEgg, UIBase)

--- @return void
function UIEventEasterEgg:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventEasterEgg:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventEasterEggModel()
	self.view = UIEventEasterEggView(self.model)
end

return UIEventEasterEgg
