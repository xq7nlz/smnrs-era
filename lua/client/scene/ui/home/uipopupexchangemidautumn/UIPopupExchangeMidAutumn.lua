require "lua.client.scene.ui.home.uiPopupExchangeMidAutumn.UIPopupExchangeMidAutumnModel"
require "lua.client.scene.ui.home.uiPopupExchangeMidAutumn.UIPopupExchangeMidAutumnView"

--- @class UIPopupExchangeMidAutumn : UIBase
UIPopupExchangeMidAutumn = Class(UIPopupExchangeMidAutumn, UIBase)

--- @return void
function UIPopupExchangeMidAutumn:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupExchangeMidAutumn:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupExchangeMidAutumnModel()
	self.view = UIPopupExchangeMidAutumnView(self.model)
end

return UIPopupExchangeMidAutumn
