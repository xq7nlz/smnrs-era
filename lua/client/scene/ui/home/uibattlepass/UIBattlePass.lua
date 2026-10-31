require "lua.client.scene.ui.home.uiBattlePass.UIBattlePassModel"
require "lua.client.scene.ui.home.uiBattlePass.UIBattlePassView"

--- @class UIBattlePass : UIBase
UIBattlePass = Class(UIBattlePass, UIBase)

--- @return void
function UIBattlePass:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIBattlePass:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIBattlePassModel()
	self.view = UIBattlePassView(self.model)
end

return UIBattlePass
