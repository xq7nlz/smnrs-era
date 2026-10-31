require "lua.client.scene.ui.home.uiDungeonShop.UIDungeonShopModel"
require "lua.client.scene.ui.home.uiDungeonShop.UIDungeonShopView"

--- @class UIDungeonShop : UIBase
UIDungeonShop = Class(UIDungeonShop, UIBase)

--- @return void
function UIDungeonShop:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDungeonShop:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDungeonShopModel()
	self.view = UIDungeonShopView(self.model, self.ctrl)
end

return UIDungeonShop
