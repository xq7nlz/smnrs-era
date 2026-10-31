require "lua.client.scene.ui.home.uiPreviewStarterPackFragment.UIPreviewStarterPackFragmentModel"
require "lua.client.scene.ui.home.uiPreviewStarterPackFragment.UIPreviewStarterPackFragmentView"

--- @class UIPreviewStarterPackFragment : UIBase
UIPreviewStarterPackFragment = Class(UIPreviewStarterPackFragment, UIBase)

--- @return void
function UIPreviewStarterPackFragment:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPreviewStarterPackFragment:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPreviewStarterPackFragmentModel()
	self.view = UIPreviewStarterPackFragmentView(self.model)
end

return UIPreviewStarterPackFragment
