require "lua.client.scene.ui.home.uiFriendMail.UIFriendMailModel"
require "lua.client.scene.ui.home.uiFriendMail.UIFriendMailView"

--- @class UIFriendMail : UIBase
UIFriendMail = Class(UIFriendMail, UIBase)

--- @return void
function UIFriendMail:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFriendMail:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFriendMailModel()
	self.view = UIFriendMailView(self.model, self.ctrl)
end

return UIFriendMail
