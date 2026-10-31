require "lua.client.scene.ui.home.uiDungeonSeller.UIDungeonSellerModel"
require "lua.client.scene.ui.home.uiDungeonSeller.UIDungeonSellerView"

--- @class UIDungeonSeller : UIBase
UIDungeonSeller = Class(UIDungeonSeller, UIBase)

--- @return void
function UIDungeonSeller:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDungeonSeller:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDungeonSellerModel()
	self.view = UIDungeonSellerView(self.model, self.ctrl)
end

return UIDungeonSeller
