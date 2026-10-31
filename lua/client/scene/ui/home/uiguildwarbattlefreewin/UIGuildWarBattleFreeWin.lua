require "lua.client.scene.ui.home.uiGuildWarBattleFreeWin.UIGuildWarBattleFreeWinModel"
require "lua.client.scene.ui.home.uiGuildWarBattleFreeWin.UIGuildWarBattleFreeWinView"

--- @class UIGuildWarBattleFreeWin : UIBase
UIGuildWarBattleFreeWin = Class(UIGuildWarBattleFreeWin, UIBase)

--- @return void
function UIGuildWarBattleFreeWin:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildWarBattleFreeWin:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildWarBattleFreeWinModel()
	self.view = UIGuildWarBattleFreeWinView(self.model)
end

return UIGuildWarBattleFreeWin
