require "lua.client.scene.ui.home.uiGuildMembersItem.UIGuildMembersItemModel"
require "lua.client.scene.ui.home.uiGuildMembersItem.UIGuildMembersItemView"

--- @class UIGuildMembersItem : UIBase
UIGuildMembersItem = Class(UIGuildMembersItem, UIBase)

--- @return void
function UIGuildMembersItem:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildMembersItem:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildMembersItemModel()
	self.view = UIGuildMembersItemView(self.model)
end

return UIGuildMembersItem
