require "lua.client.scene.ui.home.uiGuildWarBattleDefeat.UIGuildWarBattleDefeatModel"
require "lua.client.scene.ui.home.uiGuildWarBattleDefeat.UIGuildWarBattleDefeatView"

--- @class UIGuildWarBattleDefeat : UIBase
UIGuildWarBattleDefeat = Class(UIGuildWarBattleDefeat, UIBase)

--- @return void
function UIGuildWarBattleDefeat:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildWarBattleDefeat:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildWarBattleDefeatModel()
	self.view = UIGuildWarBattleDefeatView(self.model)
end

return UIGuildWarBattleDefeat
