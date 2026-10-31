
--- @class UIPopupMultiScrollRewardItemModel : UIBaseModel
UIPopupFourItemModel = Class(UIPopupFourItemModel, UIBaseModel)

--- @return void
function UIPopupFourItemModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupMultiScrollRewardItem, "ui_multi_scroll_reward_item")

	--- @type List <ItemIconData>
	self.resourceList = List()

	self.bgDark = true
end

