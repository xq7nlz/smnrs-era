
--- @class UIWheelOfFateModel : UIBaseModel
UIWheelOfFateModel = Class(UIWheelOfFateModel, UIBaseModel)

--- @return void
function UIWheelOfFateModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIWheelOfFate, "wheel_of_fate")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP
	---@type number
    self.casinoType = CasinoType.Premium
	---@type MoneyType
	self.chip = MoneyType.CASINO_BASIC_CHIP
	---@type number
	self.numberChip10 = 10
	---@type List
	self.itemConfigList = List()
	---@type List
	self.itemRewardList = List()
	---@type List
	self.listSingleClaim = List()
	---@type List
	self.listClaim = List()
	---@type Number
	self.timeRefresh = nil
end