require "lua.client.scene.ui.home.uiPopupPackOfItems.UIPopupPackOfItemsModel"
require "lua.client.scene.ui.home.uiPopupPackOfItems.UIPopupPackOfItemsView"

--- @class UIPopupPackOfItems : UIBase
UIPopupPackOfItems = Class(UIPopupPackOfItems, UIBase)

--- @return void
function UIPopupPackOfItems:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupPackOfItems:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupPackOfItemsModel()
	self.view = UIPopupPackOfItemsView(self.model, self.ctrl)
end

return UIPopupPackOfItems











