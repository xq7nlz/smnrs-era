
--- @class UIGuildDonateHistoryModel : UIBaseModel
UIGuildDonateHistoryModel = Class(UIGuildDonateHistoryModel, UIBaseModel)

--- @return void
function UIGuildDonateHistoryModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildDonateHistory, "guild_quest_donate_history")

	self.bgDark = true
end

