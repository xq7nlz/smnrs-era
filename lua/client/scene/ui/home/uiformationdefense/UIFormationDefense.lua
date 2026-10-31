require "lua.client.scene.ui.home.uiFormationDefense.UIFormationDefenseModel"
require "lua.client.scene.ui.home.uiFormationDefense.UIFormationDefenseView"

--- @class UIFormationDefense : UIBase
UIFormationDefense = Class(UIFormationDefense, UIBase)

--- @return void
function UIFormationDefense:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFormationDefense:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFormationDefenseModel()
	self.view = UIFormationDefenseView(self.model)
end

return UIFormationDefense
