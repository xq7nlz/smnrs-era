require "lua.client.scene.ui.home.uiDungeonPrimaryMerchant.UIDungeonPrimaryMerchantModel"
require "lua.client.scene.ui.home.uiDungeonPrimaryMerchant.UIDungeonPrimaryMerchantView"

--- @class UIDungeonPrimaryMerchant : UIBase
UIDungeonPrimaryMerchant = Class(UIDungeonPrimaryMerchant, UIBase)

--- @return void
function UIDungeonPrimaryMerchant:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDungeonPrimaryMerchant:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDungeonPrimaryMerchantModel()
	self.view = UIDungeonPrimaryMerchantView(self.model, self.ctrl)
end

return UIDungeonPrimaryMerchant
