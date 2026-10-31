
--- @class UIGuildWarBattleDefeatModel : UIBaseModel
UIGuildWarBattleDefeatModel = Class(UIGuildWarBattleDefeatModel, UIBaseModel)

--- @return void
function UIGuildWarBattleDefeatModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildWarBattleDefeat, "guild_war_battle_defeat")

	self.bgDark = true
end

