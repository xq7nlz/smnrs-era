require "lua.client.scene.ui.home.uiEventSkinBundle.UIEventSkinBundleModel"
require "lua.client.scene.ui.home.uiEventSkinBundle.UIEventSkinBundleView"

--- @class UIEventSkinBundle : UIBase
UIEventSkinBundle = Class(UIEventSkinBundle, UIBase)

--- @return void
function UIEventSkinBundle:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventSkinBundle:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventSkinBundleModel()
	self.view = UIEventSkinBundleView(self.model)
end

return UIEventSkinBundle
