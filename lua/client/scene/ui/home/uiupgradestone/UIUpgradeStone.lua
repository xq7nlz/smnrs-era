require "lua.client.scene.ui.home.uiUpgradeStone.UIUpgradeStoneModel"
require "lua.client.scene.ui.home.uiUpgradeStone.UIUpgradeStoneView"

--- @class UIUpgradeStone : UIBase
UIUpgradeStone = Class(UIUpgradeStone, UIBase)

--- @return void
function UIUpgradeStone:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIUpgradeStone:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIUpgradeStoneModel()
	self.view = UIUpgradeStoneView(self.model)
end

return UIUpgradeStone
