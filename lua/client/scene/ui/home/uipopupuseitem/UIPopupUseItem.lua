require "lua.client.scene.ui.home.uiPopupUseItem.UIPopupUseItemModel"
require "lua.client.scene.ui.home.uiPopupUseItem.UIPopupUseItemView"

--- @class UIPopupUseItem : UIBase
UIPopupUseItem = Class(UIPopupUseItem, UIBase)

--- @return void
function UIPopupUseItem:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupUseItem:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupUseItemModel()
	self.view = UIPopupUseItemView(self.model)
end

return UIPopupUseItem
