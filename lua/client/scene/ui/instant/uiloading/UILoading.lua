require "lua.client.scene.ui.instant.uiLoading.UILoadingModel"
require "lua.client.scene.ui.instant.uiLoading.UILoadingCtrl"
require "lua.client.scene.ui.instant.uiLoading.UILoadingView"

--- @class UILoading : UIBase
UILoading = Class(UILoading, UIBase)

--- @return void
--- @ov
function UILoading:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UILoading:OnCreate()
	UIBase.OnCreate(self)
	self.model = UILoadingModel()
	self.ctrl = UILoadingCtrl(self.model)
	self.view = UILoadingView(self.model, self.ctrl)
end

return UILoading
