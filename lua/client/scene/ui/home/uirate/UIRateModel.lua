
--- @class UIRateModel : UIBaseModel
UIRateModel = Class(UIRateModel, UIBaseModel)

--- @return void
function UIRateModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIRate, "rate")
	self.bgDark = true
end

