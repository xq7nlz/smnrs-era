
--- @class UIPopupUseItemModel : UIBaseModel
UIPopupUseItemModel = Class(UIPopupUseItemModel, UIBaseModel)

--- @return void
function UIPopupUseItemModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupUseItem, "popup_use_item")

	self.bgDark = true
end

