require "lua.client.scene.ui.home.uiEventLunarNewYear2024.UIEventLunarNewYear2024Model"
require "lua.client.scene.ui.home.uiEventLunarNewYear2024.UIEventLunarNewYear2024View"

--- @class UIEventLunarNewYear2024 : UIBase
UIEventLunarNewYear2024 = Class(UIEventLunarNewYear2024, UIBase)

--- @return void
function UIEventLunarNewYear2024:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventLunarNewYear2024:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventLunarNewYear2024Model()
	self.view = UIEventLunarNewYear2024View(self.model)
end

return UIEventLunarNewYear2024
