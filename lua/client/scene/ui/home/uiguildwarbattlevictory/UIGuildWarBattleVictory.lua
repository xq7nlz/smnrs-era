require "lua.client.scene.ui.home.uiGuildWarBattleVictory.UIGuildWarBattleVictoryModel"
require "lua.client.scene.ui.home.uiGuildWarBattleVictory.UIGuildWarBattleVictoryView"

--- @class UIGuildWarBattleVictory : UIBase
UIGuildWarBattleVictory = Class(UIGuildWarBattleVictory, UIBase)

--- @return void
function UIGuildWarBattleVictory:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildWarBattleVictory:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildWarBattleVictoryModel()
	self.view = UIGuildWarBattleVictoryView(self.model)
end

return UIGuildWarBattleVictory
