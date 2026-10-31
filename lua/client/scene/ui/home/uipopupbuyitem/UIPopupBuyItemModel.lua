
--- @class UIPopupBuyItemModel : UIBaseModel
UIPopupBuyItemModel = Class(UIPopupBuyItemModel, UIBaseModel)

--- @return void
function UIPopupBuyItemModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupBuyItem, "popup_buy_item")
	---@type PopupBuyItemData
    self.data = nil
	---@type number
	self.priceTotal = nil

	self.bgDark = true
end

