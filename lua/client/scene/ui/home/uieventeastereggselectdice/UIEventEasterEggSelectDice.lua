require "lua.client.scene.ui.home.uiEventEasterEggSelectDice.UIEventEasterEggSelectDiceModel"
require "lua.client.scene.ui.home.uiEventEasterEggSelectDice.UIEventEasterEggSelectDiceView"

--- @class UISelectDicePopup : UIBase
UISelectDicePopup = Class(UISelectDicePopup, UIBase)

--- @return void
function UISelectDicePopup:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectDicePopup:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventEasterEggSelectDiceModel()
	self.view = UIEventEasterEggSelectDiceViewView(self.model)
end

return UISelectDicePopup
