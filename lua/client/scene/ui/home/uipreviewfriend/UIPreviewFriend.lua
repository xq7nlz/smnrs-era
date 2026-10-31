require "lua.client.scene.ui.home.uiPreviewFriend.UIPreviewFriendModel"
require "lua.client.scene.ui.home.uiPreviewFriend.UIPreviewFriendView"

--- @class UIPreviewFriend : UIBase
UIPreviewFriend = Class(UIPreviewFriend, UIBase)

--- @return void
function UIPreviewFriend:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPreviewFriend:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPreviewFriendModel()
	self.view = UIPreviewFriendView(self.model, self.ctrl)
end

return UIPreviewFriend
