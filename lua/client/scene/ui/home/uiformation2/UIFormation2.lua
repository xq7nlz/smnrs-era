require "lua.client.scene.ui.home.uiFormation2.UIFormation2Model"
require "lua.client.scene.ui.home.uiFormation2.UIFormation2View"
require "lua.client.scene.ui.home.uiFormation2.UIFormation2Ctrl"

--- @class UIFormation2 : UIBase
UIFormation2 = Class(UIFormation2, UIBase)

--- @return void
function UIFormation2:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFormation2:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFormation2Model()
	self.ctrl = UIFormation2Ctrl(self.model)
	self.view = UIFormation2View(self.model, self.ctrl)
end

return UIFormation2
