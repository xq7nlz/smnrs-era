
--- @class UIPopupFakeDataModel : UIBaseModel
UIPopupFakeDataModel = Class(UIPopupFakeDataModel, UIBaseModel)

--- @return void
function UIPopupFakeDataModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupFakeData, "fake_data")

	self.bgDark = true
end

