require "lua.client.scene.ui.home.uiDungeonPotionBag.UIDungeonPotionBagModel"
require "lua.client.scene.ui.home.uiDungeonPotionBag.UIDungeonPotionBagView"

--- @class UIDungeonPotionBag : UIBase
UIDungeonPotionBag = Class(UIDungeonPotionBag, UIBase)

--- @return void
function UIDungeonPotionBag:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDungeonPotionBag:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDungeonPotionBagModel()
	self.view = UIDungeonPotionBagView(self.model)
end

return UIDungeonPotionBag
