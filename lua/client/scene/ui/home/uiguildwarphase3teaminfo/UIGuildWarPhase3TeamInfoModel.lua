
--- @class UIGuildWarPhase3TeamInfoModel : UIBaseModel
UIGuildWarPhase3TeamInfoModel = Class(UIGuildWarPhase3TeamInfoModel, UIBaseModel)

--- @return void
function UIGuildWarPhase3TeamInfoModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildWarPhase3TeamInfo, "guild_war_phase_3_team_info")

	self.bgDark = true
end

