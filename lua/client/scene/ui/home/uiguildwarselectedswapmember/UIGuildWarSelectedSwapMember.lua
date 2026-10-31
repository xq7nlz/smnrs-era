require "lua.client.scene.ui.home.uiGuildWarSelectedSwapMember.UIGuildWarSelectedSwapMemberModel"
require "lua.client.scene.ui.home.uiGuildWarSelectedSwapMember.UIGuildWarSelectedSwapMemberView"

--- @class UIGuildWarSelectedSwapMember : UIBase
UIGuildWarSelectedSwapMember = Class(UIGuildWarSelectedSwapMember, UIBase)

--- @return void
function UIGuildWarSelectedSwapMember:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildWarSelectedSwapMember:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildWarSelectedSwapMemberModel()
	self.view = UIGuildWarSelectedSwapMemberView(self.model)
end

return UIGuildWarSelectedSwapMember
