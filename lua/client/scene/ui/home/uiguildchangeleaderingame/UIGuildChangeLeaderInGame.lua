require "lua.client.scene.ui.home.uiGuildChangeLeaderInGame.UIGuildChangeLeaderInGameModel"
require "lua.client.scene.ui.home.uiGuildChangeLeaderInGame.UIGuildChangeLeaderInGameView"

--- @class UIGuildChangeLeaderInGame : UIBase
UIGuildChangeLeaderInGame = Class(UIGuildChangeLeaderInGame, UIBase)

--- @return void
function UIGuildChangeLeaderInGame:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildChangeLeaderInGame:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildChangeLeaderInGameModel()
	self.view = UIGuildChangeLeaderInGameView(self.model)
end

return UIGuildChangeLeaderInGame
