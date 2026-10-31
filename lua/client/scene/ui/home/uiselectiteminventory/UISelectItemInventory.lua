require "lua.client.scene.ui.home.uiSelectItemInventory.UISelectItemInventoryModel"
require "lua.client.scene.ui.home.uiSelectItemInventory.UISelectItemInventoryView"

--- @class UISelectItemInventory
UISelectItemInventory = Class(UISelectItemInventory, UIBase)

--- @return void
function UISelectItemInventory:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectItemInventory:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectItemInventoryModel()
	self.view = UISelectItemInventoryView(self.model, self.ctrl)
end

return UISelectItemInventory
