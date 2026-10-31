require "lua.client.scene.ui.home.uiPopupExchange.UIPopupExchangeModel"
require "lua.client.scene.ui.home.uiPopupExchange.UIPopupExchangeView"

--- @class UIPopupExchange : UIBase
UIPopupExchange = Class(UIPopupExchange, UIBase)

--- @return void
function UIPopupExchange:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupExchange:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupExchangeModel()
	self.view = UIPopupExchangeView(self.model)
end

return UIPopupExchange
