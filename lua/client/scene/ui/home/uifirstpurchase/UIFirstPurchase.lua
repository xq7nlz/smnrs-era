require "lua.client.scene.ui.home.uiFirstPurchase.UIFirstPurchaseModel"
require "lua.client.scene.ui.home.uiFirstPurchase.UIFirstPurchaseView"

--- @class UIFirstPurchase : UIBase
UIFirstPurchase = Class(UIFirstPurchase, UIBase)

--- @return void
function UIFirstPurchase:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFirstPurchase:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFirstPurchaseModel()
	self.view = UIFirstPurchaseView(self.model, self.ctrl)
end

return UIFirstPurchase
