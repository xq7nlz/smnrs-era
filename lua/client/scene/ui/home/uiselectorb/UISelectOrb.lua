require "lua.client.scene.ui.home.uiSelectOrb.UISelectOrbModel"
require "lua.client.scene.ui.home.uiSelectOrb.UISelectOrbView"

--- @class UISelectOrb : UIBase
UISelectOrb = Class(UISelectOrb, UIBase)

--- @return void
function UISelectOrb:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectOrb:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectOrbModel()
	self.view = UISelectOrbView(self.model)
end

return UISelectOrb
