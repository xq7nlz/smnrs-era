require "lua.client.scene.ui.home.uiPopupBuyItem.UIPopupBuyItemModel"
require "lua.client.scene.ui.home.uiPopupBuyItem.UIPopupBuyItemView"

--- @class UIPopupBuyItem : UIBase
UIPopupBuyItem = Class(UIPopupBuyItem, UIBase)

--- @return void
function UIPopupBuyItem:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupBuyItem:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupBuyItemModel()
	self.view = UIPopupBuyItemView(self.model, self.ctrl)
end

return UIPopupBuyItem
