require "lua.client.scene.ui.home.uiChat.UIChatModel"
require "lua.client.scene.ui.home.uiChat.UIChatView"

--- @class UIChat : UIBase
UIChat = Class(UIChat, UIBase)

--- @return void
function UIChat:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIChat:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIChatModel()
	self.view = UIChatView(self.model)
end

return UIChat
