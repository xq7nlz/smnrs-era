require "lua.client.scene.ui.home.uiPopupMultiScrollRewardItem.UIPopupMultiScrollRewardItemModel"
require "lua.client.scene.ui.home.uiPopupMultiScrollRewardItem.UIPopupMultiScrollRewardItemView"

--- @class UIPopupMultiScrollRewardItem : UIBase
UIPopupMultiScrollRewardItem = Class(UIPopupMultiScrollRewardItem, UIBase)

--- @return void
function UIPopupMultiScrollRewardItem:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupMultiScrollRewardItem:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupFourItemModel()
	self.view = UIPopupMultiScrollRewardItemView(self.model)
end

return UIPopupMultiScrollRewardItem
