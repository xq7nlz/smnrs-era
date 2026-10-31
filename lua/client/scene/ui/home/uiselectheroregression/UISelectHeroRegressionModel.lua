
--- @class UISelectHeroRegressionModel : UIBaseModel
UISelectHeroRegressionModel = Class(UISelectHeroRegressionModel, UIBaseModel)

--- @return void
function UISelectHeroRegressionModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectHeroRegression, "select_heroes_regression")
	self.bgDark = true
end

