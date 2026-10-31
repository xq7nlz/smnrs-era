require "lua.client.scene.ui.home.uiSelectMaterial.UISelectMaterialModel"
require "lua.client.scene.ui.home.uiSelectMaterial.UISelectMaterialView"

--- @class UISelectMaterial : UIBase
UISelectMaterial = Class(UISelectMaterial, UIBase)

--- @return void
function UISelectMaterial:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectMaterial:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectMaterialModel()
	self.view = UISelectMaterialView(self.model)
end

return UISelectMaterial
