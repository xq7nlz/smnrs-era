require "lua.client.scene.ui.home.uiPreviewTigerHeroFragment.UIPreviewTigerHeroFragmentModel"
require "lua.client.scene.ui.home.uiPreviewTigerHeroFragment.UIPreviewTigerHeroFragmentView"

--- @class UIPreviewTigerPathHeroFragment : UIBase
UIPreviewTigerPathHeroFragment = Class(UIPreviewTigerPathHeroFragment, UIBase)

--- @return void
function UIPreviewTigerPathHeroFragment:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPreviewTigerPathHeroFragment:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPreviewTigerHeroFragmentModel()
	self.view = UIPreviewTigerHeroFragmentView(self.model)
end

return UIPreviewTigerPathHeroFragment
