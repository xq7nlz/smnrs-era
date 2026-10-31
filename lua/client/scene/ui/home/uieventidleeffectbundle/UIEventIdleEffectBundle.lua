require "lua.client.scene.ui.home.uiEventIdleEffectBundle.UIEventIdleEffectBundleModel"
require "lua.client.scene.ui.home.uiEventIdleEffectBundle.UIEventIdleEffectBundleView"

--- @class UIEventIdleEffectBundle : UIBase
UIEventIdleEffectBundle = Class(UIEventIdleEffectBundle, UIBase)

--- @return void
function UIEventIdleEffectBundle:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventIdleEffectBundle:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventIdleEffectBundleModel()
	self.view = UIEventIdleEffectBundleView(self.model)
end

return UIEventIdleEffectBundle
