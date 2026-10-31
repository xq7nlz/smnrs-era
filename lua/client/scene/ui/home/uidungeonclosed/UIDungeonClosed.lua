require "lua.client.scene.ui.home.uiDungeonClosed.UIDungeonClosedModel"
require "lua.client.scene.ui.home.uiDungeonClosed.UIDungeonClosedView"

--- @class UIDungeonClosed : UIBase
UIDungeonClosed = Class(UIDungeonClosed, UIBase)

--- @return void
function UIDungeonClosed:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDungeonClosed:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDungeonClosedModel()
	self.view = UIDungeonClosedView(self.model, self.ctrl)
end

return UIDungeonClosed
