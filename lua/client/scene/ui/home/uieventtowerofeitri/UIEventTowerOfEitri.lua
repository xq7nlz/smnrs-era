require "lua.client.scene.ui.home.uiEventTowerOfEitri.UIEventTowerOfEitriModel"
require "lua.client.scene.ui.home.uiEventTowerOfEitri.UIEventTowerOfEitriView"

--- @class UIEventTowerOfEitri : UIBase
UIEventTowerOfEitri = Class(UIEventTowerOfEitri, UIBase)

--- @return void
function UIEventTowerOfEitri:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventTowerOfEitri:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventTowerOfEitriModel()
	self.view = UIEventTowerOfEitriView(self.model)
end

return UIEventTowerOfEitri
