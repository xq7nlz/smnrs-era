require "lua.client.scene.ui.home.uiPreviewIdleEffectFragment.UIPreviewIdleEffectFragmentModel"
require "lua.client.scene.ui.home.uiPreviewIdleEffectFragment.UIPreviewIdleEffectFragmentView"

--- @class UIPreviewIdleEffectFragment : UIBase
UIPreviewIdleEffectFragment = Class(UIPreviewIdleEffectFragment, UIBase)

--- @return void
function UIPreviewIdleEffectFragment:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPreviewIdleEffectFragment:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPreviewIdleEffectFragmentModel()
	self.view = UIPreviewIdleEffectFragmentView(self.model)
end

return UIPreviewIdleEffectFragment
