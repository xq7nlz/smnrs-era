
--- @class UIGuildWarSelectedSwapMemberModel : UIBaseModel
UIGuildWarSelectedSwapMemberModel = Class(UIGuildWarSelectedSwapMemberModel, UIBaseModel)

--- @return void
function UIGuildWarSelectedSwapMemberModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildWarSelectedSwapMember, "guild_war_selected_swap_member_info")

	self.bgDark = true
end

