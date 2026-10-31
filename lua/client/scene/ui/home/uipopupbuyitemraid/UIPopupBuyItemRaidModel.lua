
--- @class UIPopupBuyItemRaidModel : UIBaseModel
UIPopupBuyItemRaidModel = Class(UIPopupBuyItemRaidModel, UIBaseModel)

--- @return void
function UIPopupBuyItemRaidModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupBuyItemRaid, "popup_buy_item_raid")
	---@type PopupBuyItemRaidData
	self.data = nil
	---@type number
	self.priceTotal = nil

	self.bgDark = true
end

