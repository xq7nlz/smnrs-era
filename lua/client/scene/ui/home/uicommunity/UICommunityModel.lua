
--- @class UICommunityModel : UIBaseModel
UICommunityModel = Class(UICommunityModel, UIBaseModel)

--- @return void
function UICommunityModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UICommunity, "community")

	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = false
end

