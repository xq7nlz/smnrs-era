
--- @class UIGuildMemberInfoModel : UIBaseModel
UIGuildMemberInfoModel = Class(UIGuildMemberInfoModel, UIBaseModel)

--- @return void
function UIGuildMemberInfoModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildMemberInfo, "guild_member_info")

	--- @type GuildRole
	self.selfRole = nil
	--- @type GuildRole
	self.memberRole = nil

	--- @type GuildMemberInBound
	self.guildMemberInfo = nil

	self.bgDark = true
end

