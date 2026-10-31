
--- @class UIPopupBuyItemStringModel : UIBaseModel
UIPopupBuyItemStringModel = Class(UIPopupBuyItemStringModel, UIBaseModel)

--- @return void
function UIPopupBuyItemStringModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupBuyItemString, "popup_buy_item_string")
	---@type PopupBuyItemData
	self.data = nil
	---@type number
	self.priceTotal = nil

	self.bgDark = true
end

