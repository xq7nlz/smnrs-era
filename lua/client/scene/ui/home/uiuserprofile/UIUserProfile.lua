require "lua.client.scene.ui.home.uiUserProfile.UIUserProfileModel"
require "lua.client.scene.ui.home.uiUserProfile.UIUserProfileView"

--- @class UIUserProfile : UIBase
UIUserProfile = Class(UIUserProfile, UIBase)

--- @return void
function UIUserProfile:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIUserProfile:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIUserProfileModel()
	self.view = UIUserProfileView(self.model, self.ctrl)
end

return UIUserProfile