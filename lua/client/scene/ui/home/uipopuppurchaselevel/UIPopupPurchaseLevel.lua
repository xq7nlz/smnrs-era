require "lua.client.scene.ui.home.uiPopupPurchaseLevel.UIPopupPurchaseLevelModel"
require "lua.client.scene.ui.home.uiPopupPurchaseLevel.UIPopupPurchaseLevelView"

--- @class UIPopupPurchaseLevel : UIBase
UIPopupPurchaseLevel = Class(UIPopupPurchaseLevel, UIBase)

--- @return void
function UIPopupPurchaseLevel:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupPurchaseLevel:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupPurchaseLevelModel()
	self.view = UIPopupPurchaseLevelView(self.model)
end

return UIPopupPurchaseLevel
