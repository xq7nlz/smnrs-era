require "lua.client.scene.ui.home.uiPopupBuyItemString.UIPopupBuyItemStringModel"
require "lua.client.scene.ui.home.uiPopupBuyItemString.UIPopupBuyItemStringView"
require "lua.client.scene.ui.home.uiPopupBuyItemString.UIPopupBuyItemStringCtrl"

--- @class UIPopupBuyItemString : UIBase
UIPopupBuyItemString = Class(UIPopupBuyItemString, UIBase)

--- @return void
function UIPopupBuyItemString:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupBuyItemString:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupBuyItemStringModel()
	self.ctrl = UIPopupBuyItemStringCtrl(self.model)
	self.view = UIPopupBuyItemStringView(self.model, self.ctrl)
end

return UIPopupBuyItemString
