require "lua.client.scene.ui.home.uiMidAutumnAreaBet.UIMidAutumnAreaBetModel"
require "lua.client.scene.ui.home.uiMidAutumnAreaBet.UIMidAutumnAreaBetView"

--- @class UIMidAutumnAreaBet : UIBase
UIMidAutumnAreaBet = Class(UIMidAutumnAreaBet, UIBase)

--- @return void
function UIMidAutumnAreaBet:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIMidAutumnAreaBet:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIMidAutumnAreaBetModel()
	self.view = UIMidAutumnAreaBetView(self.model)
end

return UIMidAutumnAreaBet
