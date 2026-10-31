
--- @class UICheckDataModel : UIBaseModel
UICheckDataModel = Class(UICheckDataModel, UIBaseModel)

--- @return void
function UICheckDataModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UICheckData, "popup_check_data")
end

