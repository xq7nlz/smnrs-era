require "lua.client.scene.ui.home.uiBattlePassExchange.UIBattlePassExchangeModel"
require "lua.client.scene.ui.home.uiBattlePassExchange.UIBattlePassExchangeView"

--- @class UIBattlePassExchange : UIBase
UIBattlePassExchange = Class(UIBattlePassExchange, UIBase)

--- @return void
function UIBattlePassExchange:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIBattlePassExchange:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIBattlePassExchangeModel()
	self.view = UIBattlePassExchangeView(self.model)
end

return UIBattlePassExchange
