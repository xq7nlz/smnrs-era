
--- @class UISmashPopupModel : UIBaseModel
UISmashPopupModel = Class(UISmashPopupModel, UIBaseModel)

--- @return void
function UISmashPopupModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISmashPopup, "smash_popup")
	---@type number
	self.number = nil
	---@type number
	self.minInput = nil
	---@type number
	self.maxInput = nil
	---@type MoneyType
	self.moneyType = nil

	self.bgDark = true
end
