require "lua.client.scene.ui.home.uiEventValentine2024.UIEventValentine2024Model"
require "lua.client.scene.ui.home.uiEventValentine2024.UIEventValentine2024View"

--- @class UIEventValentine2024 : UIBase
UIEventValentine2024 = Class(UIEventValentine2024, UIBase)

--- @return void
function UIEventValentine2024:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventValentine2024:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventValentine2024Model()
	self.view = UIEventValentine2024View(self.model)
end

return UIEventValentine2024
