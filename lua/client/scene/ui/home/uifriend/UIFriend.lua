require "lua.client.scene.ui.home.uiFriend.UIFriendModel"
require "lua.client.scene.ui.home.uiFriend.UIFriendView"

--- @class UIFriend : UIBase
UIFriend = Class(UIFriend, UIBase)

--- @return void
function UIFriend:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFriend:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFriendModel()
	self.view = UIFriendView(self.model)
end

return UIFriend
