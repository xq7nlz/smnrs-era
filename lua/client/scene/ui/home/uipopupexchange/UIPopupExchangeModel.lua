
--- @class UIPopupExchangeModel : UIBaseModel
UIPopupExchangeModel = Class(UIPopupExchangeModel, UIBaseModel)

--- @return void
function UIPopupExchangeModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupExchange, "popup_exchange")

	self.bgDark = true
end

