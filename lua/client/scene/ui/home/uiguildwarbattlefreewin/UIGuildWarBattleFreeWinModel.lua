
--- @class UIGuildWarBattleFreeWinModel : UIBaseModel
UIGuildWarBattleFreeWinModel = Class(UIGuildWarBattleFreeWinModel, UIBaseModel)

--- @return void
function UIGuildWarBattleFreeWinModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildWarBattleFreeWin, "guild_war_battle_free_win")

	self.bgDark = true
end

