require "lua.client.scene.ui.home.uiFormation.UIFormationModel"
require "lua.client.scene.ui.home.uiFormation.UIFormationView"

--- @class UIFormation : UIBase
UIFormation = Class(UIFormation, UIBase)

--- @return void
function UIFormation:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFormation:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFormationModel()
	self.view = UIFormationView(self.model)
end

return UIFormation
