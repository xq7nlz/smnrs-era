
--- @class UIChangeAvatarModel : UIBaseModel
UIChangeAvatarModel = Class(UIChangeAvatarModel, UIBaseModel)

--- @return void
function UIChangeAvatarModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIChangeAvatar, "change_avatar")

	self.bgDark = true
end

