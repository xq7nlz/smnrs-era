
--- @class UIUnlockFeatureModel : UIBaseModel
UIUnlockFeatureModel = Class(UIUnlockFeatureModel, UIBaseModel)

--- @return void
function UIUnlockFeatureModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIUnlockFeature, "unlock_feature")

	self.bgDark = true
end

