require "lua.client.scene.ui.home.uiBoostFirstPurchase.UIBoostFirstPurchaseModel"
require "lua.client.scene.ui.home.uiBoostFirstPurchase.UIBoostFirstPurchaseView"

--- @class UIBoostFirstPurchase : UIBase
UIBoostFirstPurchase = Class(UIBoostFirstPurchase, UIBase)

--- @return void
function UIBoostFirstPurchase:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIBoostFirstPurchase:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIBoostFirstPurchaseModel()
	self.view = UIBoostFirstPurchaseView(self.model)
end

return UIBoostFirstPurchase
