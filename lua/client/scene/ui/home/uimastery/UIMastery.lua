require "lua.client.scene.ui.home.uiMastery.UIMasteryModel"
require "lua.client.scene.ui.home.uiMastery.UIMasteryView"

--- @class UIMastery : UIBase
UIMastery = Class(UIMastery, UIBase)

--- @return void
function UIMastery:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIMastery:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIMasteryModel()
	self.view = UIMasteryView(self.model, self.ctrl)
end

return UIMastery
