require "lua.client.scene.ui.home.uiPopupPurchaseItems.UIPopupPurchaseItemsModel"
require "lua.client.scene.ui.home.uiPopupPurchaseItems.UIPopupPurchaseItemsView"

--- @class UIPopupPurchaseItems : UIBase
UIPopupPurchaseItems = Class(UIPopupPurchaseItems, UIBase)

--- @return void
function UIPopupPurchaseItems:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupPurchaseItems:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupPurchaseItemsModel()
	self.view = UIPopupPurchaseItemsView(self.model, self.ctrl)
end

return UIPopupPurchaseItems
