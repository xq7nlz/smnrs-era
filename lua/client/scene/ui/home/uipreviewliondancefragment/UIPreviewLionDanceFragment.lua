require "lua.client.scene.ui.home.uiPreviewLionDanceFragment.UIPreviewLionDanceFragmentModel"
require "lua.client.scene.ui.home.uiPreviewLionDanceFragment.UIPreviewLionDanceFragmentView"

--- @class UIPreviewLionDanceHeroFragment : UIBase
UIPreviewLionDanceHeroFragment = Class(UIPreviewLionDanceHeroFragment, UIBase)

--- @return void
function UIPreviewLionDanceHeroFragment:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPreviewLionDanceHeroFragment:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPreviewLionDanceFragmentModel()
	self.view = UIPreviewLionDanceFragmentView(self.model)
end

return UIPreviewLionDanceHeroFragment
