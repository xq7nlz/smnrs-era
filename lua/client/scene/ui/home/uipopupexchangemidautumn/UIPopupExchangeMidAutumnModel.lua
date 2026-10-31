
--- @class UIPopupExchangeMidAutumnModel : UIBaseModel
UIPopupExchangeMidAutumnModel = Class(UIPopupExchangeMidAutumnModel, UIBaseModel)

--- @return void
function UIPopupExchangeMidAutumnModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupExchangeMidAutumn, "popup_exchange_mid_autumn")
	self.bgDark = true
end

