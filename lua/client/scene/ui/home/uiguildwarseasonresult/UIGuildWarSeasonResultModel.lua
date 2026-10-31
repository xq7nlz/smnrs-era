
--- @class UIGuildWarSeasonResultModel : UIBaseModel
UIGuildWarSeasonResultModel = Class(UIGuildWarSeasonResultModel, UIBaseModel)

--- @return void
function UIGuildWarSeasonResultModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildWarSeasonResult, "guild_war_season_reward")

	self.bgDark = true
end

