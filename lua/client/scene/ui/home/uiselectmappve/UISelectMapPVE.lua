require "lua.client.scene.ui.home.uiSelectMapPVE.UISelectMapPVEModel"
require "lua.client.scene.ui.home.uiSelectMapPVE.UISelectMapPVEView"

--- @class UISelectMapPVE
UISelectMapPVE = Class(UISelectMapPVE, UIBase)

--- @return void
function UISelectMapPVE:Ctor()
	UIBase.Ctor(self)

end

--- @return void
function UISelectMapPVE:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectMapPVEModel()
	self.view = UISelectMapPVEView(self.model, self.ctrl)
end

return UISelectMapPVE
