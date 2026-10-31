require "lua.client.scene.ui.instant.uiPopupWaiting.UIPopupWaitingView"
require "lua.client.scene.ui.instant.uiPopupWaiting.UIPopupWaitingModel"

--- @class UIPopupWaiting : UIBase
UIPopupWaiting = Class(UIPopupWaiting, UIBase)

--- @return void
function UIPopupWaiting:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupWaiting:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupWaitingModel()
	self.view = UIPopupWaitingView(self.model)
end

return UIPopupWaiting
