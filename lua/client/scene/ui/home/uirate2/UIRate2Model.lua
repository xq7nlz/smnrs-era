
--- @class UIRate2Model : UIRateModel
UIRate2Model = Class(UIRate2Model, UIRateModel)

--- @return void
function UIRate2Model:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIRate2, "rate_2")
	self.bgDark = true
end

