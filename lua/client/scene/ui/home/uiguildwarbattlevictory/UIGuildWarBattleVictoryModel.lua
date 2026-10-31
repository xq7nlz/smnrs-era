
--- @class UIGuildWarBattleVictoryModel : UIBaseModel
UIGuildWarBattleVictoryModel = Class(UIGuildWarBattleVictoryModel, UIBaseModel)

--- @return void
function UIGuildWarBattleVictoryModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildWarBattleVictory, "guild_war_battle_victory")

	self.bgDark = true
end

