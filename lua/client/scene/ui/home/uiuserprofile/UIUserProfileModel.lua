
--- @class UIUserProfileModel : UIBaseModel
UIUserProfileModel = Class(UIUserProfileModel, UIBaseModel)

--- @return void
function UIUserProfileModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIUserProfile, "user_profile")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = false
end

