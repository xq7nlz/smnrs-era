require "lua.client.scene.ui.home.uiChangeAvatar.UIChangeAvatarModel"
require "lua.client.scene.ui.home.uiChangeAvatar.UIChangeAvatarView"

--- @class UIChangeAvatar : UIBase
UIChangeAvatar = Class(UIChangeAvatar, UIBase)

--- @return void
function UIChangeAvatar:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIChangeAvatar:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIChangeAvatarModel()
	self.view = UIChangeAvatarView(self.model)
end

return UIChangeAvatar
