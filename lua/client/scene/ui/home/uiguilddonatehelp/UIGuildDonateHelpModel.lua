
--- @class UIGuildDonateHelpModel : UIBaseModel
UIGuildDonateHelpModel = Class(UIGuildDonateHelpModel, UIBaseModel)

--- @return void
function UIGuildDonateHelpModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildDonateHelp, "guild_quest_donate_help")

	self.bgDark = true
end

