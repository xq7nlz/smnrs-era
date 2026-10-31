
--- @class UIGuildChangeLeaderInGameModel : UIBaseModel
UIGuildChangeLeaderInGameModel = Class(UIGuildChangeLeaderInGameModel, UIBaseModel)

--- @return void
function UIGuildChangeLeaderInGameModel:Ctor()

	UIBaseModel.Ctor(self, UIPopupName.UIGuildChangeLeaderInGame, "guild_change_leader_ingame")
	self.bgDark = true
	self.type = UIPopupType.BLUR_POPUP
end

