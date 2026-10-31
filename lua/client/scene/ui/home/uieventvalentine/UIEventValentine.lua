require "lua.client.scene.ui.home.uiEventValentine.UIEventValentineModel"
require "lua.client.scene.ui.home.uiEventValentine.UIEventValentineView"

--- @class UIEventValentine : UIBase
UIEventValentine = Class(UIEventValentine, UIBase)

--- @return void
function UIEventValentine:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventValentine:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventValentineModel()
	self.view = UIEventValentineView(self.model)
end

return UIEventValentine
