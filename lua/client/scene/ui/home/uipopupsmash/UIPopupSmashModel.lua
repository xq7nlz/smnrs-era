
--- @class UIPopupSmashModel : UIBaseModel
UIPopupSmashModel = Class(UIPopupSmashModel, UIBaseModel)

--- @return void
function UIPopupSmashModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupSmash, "popup_smash")
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

