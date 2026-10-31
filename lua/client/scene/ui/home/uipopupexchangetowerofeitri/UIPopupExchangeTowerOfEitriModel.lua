
--- @class UIPopupExchangeTowerOfEitriModel : UIBaseModel
UIPopupExchangeTowerOfEitriModel = Class(UIPopupExchangeTowerOfEitriModel, UIBaseModel)

--- @return void
function UIPopupExchangeTowerOfEitriModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupExchangeTowerOfEitri, "popup_exchange_tower_of_eitri")
	self.bgDark = true
end

