require "lua.client.scene.ui.home.uiPopupSummonItem.UIPopupSummonItemModel"
require "lua.client.scene.ui.home.uiPopupSummonItem.UIPopupSummonItemView"

--- @class UIPopupSummonItem : UIBase
UIPopupSummonItem = Class(UIPopupSummonItem, UIBase)

--- @return void
function UIPopupSummonItem:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupSummonItem:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupSummonItemModel()
	self.view = UIPopupSummonItemView(self.model, self.ctrl)
end

return UIPopupSummonItem
