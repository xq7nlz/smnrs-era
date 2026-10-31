require "lua.client.scene.ui.home.uiInventory.UIInventoryModel"
require "lua.client.scene.ui.home.uiInventory.UIInventoryView"

--- @class UIInventory : UIBase
UIInventory = Class(UIInventory, UIBase)

--- @return void
function UIInventory:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIInventory:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIInventoryModel()
	self.view = UIInventoryView(self.model, self.ctrl)
end

return UIInventory
