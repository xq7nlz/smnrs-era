require "lua.client.scene.ui.battle.uiBattleLog.UIBattleLogModel"
require "lua.client.scene.ui.battle.uiBattleLog.UIBattleLogView"

--- @class UIBattleLog
UIBattleLog = Class(UIBattleLog, UIBase)

--- @return void
function UIBattleLog:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIBattleLog:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIBattleLogModel()
	 --self.ctrl = UIBattleLogCtrl(self.model)
	self.view = UIBattleLogView(self.model, self.ctrl)
end

return UIBattleLog
