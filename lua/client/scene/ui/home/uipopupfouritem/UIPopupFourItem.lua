require "lua.client.scene.ui.home.uiPopupFourItem.UIPopupFourItemModel"
require "lua.client.scene.ui.home.uiPopupFourItem.UIPopupFourItemView"

--- @class UIPopupFourItem : UIBase
UIPopupFourItem = Class(UIPopupFourItem, UIBase)

--- @return void
function UIPopupFourItem:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupFourItem:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupFourItemModel()
	self.view = UIPopupFourItemView(self.model)
end

return UIPopupFourItem
