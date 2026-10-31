
--- @class UIGuildFoundationModel : UIBaseModel
UIGuildFoundationModel = Class(UIGuildFoundationModel, UIBaseModel)

--- @return void
function UIGuildFoundationModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildFoundation, "guild_foundation")

	--- @type GuildInfoInBound
	self.guildInfoInBound = nil
	--- @type MoneyType
	self.foundMoneyType = MoneyType.GEM
	--- @type number
	self.avatarId = 1

	self.bgDark = true
end

