require "lua.client.scene.ui.home.uiUnlockFeature.UIUnlockFeatureModel"
require "lua.client.scene.ui.home.uiUnlockFeature.UIUnlockFeatureView"

--- @class UIUnlockFeature : UIBase
UIUnlockFeature = Class(UIUnlockFeature, UIBase)

--- @return void
function UIUnlockFeature:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIUnlockFeature:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIUnlockFeatureModel()
	self.view = UIUnlockFeatureView(self.model, self.ctrl)
end

return UIUnlockFeature
