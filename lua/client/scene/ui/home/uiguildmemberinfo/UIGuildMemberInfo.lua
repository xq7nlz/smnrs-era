require "lua.client.scene.ui.home.uiGuildMemberInfo.UIGuildMemberInfoModel"
require "lua.client.scene.ui.home.uiGuildMemberInfo.UIGuildMemberInfoView"

--- @class UIGuildMemberInfo : UIBase
UIGuildMemberInfo = Class(UIGuildMemberInfo, UIBase)

--- @return void
function UIGuildMemberInfo:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildMemberInfo:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildMemberInfoModel()
	self.view = UIGuildMemberInfoView(self.model, self.ctrl)
end

return UIGuildMemberInfo
