require "lua.client.scene.ui.home.uiQuickBattle.UIQuickBattleModel"
require "lua.client.scene.ui.home.uiQuickBattle.UIQuickBattleView"

--- @class UIQuickBattle : UIBase
UIQuickBattle = Class(UIQuickBattle, UIBase)

--- @return void
function UIQuickBattle:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIQuickBattle:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIQuickBattleModel()
	self.view = UIQuickBattleView(self.model, self.ctrl)
end

return UIQuickBattle
