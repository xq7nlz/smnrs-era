
--- @class UIGuildWarRewardModel : UIBaseModel
UIGuildWarRewardModel = Class(UIGuildWarRewardModel, UIBaseModel)

--- @return void
function UIGuildWarRewardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildWarReward, "guild_war_reward")

	self.bgDark = true
end

