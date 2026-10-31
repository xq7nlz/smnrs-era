require "lua.client.scene.ui.home.uiPreviewServerWeekFragment.UIPreviewServerWeekFragmentModel"
require "lua.client.scene.ui.home.uiPreviewServerWeekFragment.UIPreviewServerWeekFragmentView"

--- @class UIPreviewServerWeekFragment : UIBase
UIPreviewServerWeekFragment = Class(UIPreviewServerWeekFragment, UIBase)

--- @return void
function UIPreviewServerWeekFragment:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPreviewServerWeekFragment:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPreviewServerWeekFragmentModel()
	self.view = UIPreviewServerWeekFragmentView(self.model)
end

return UIPreviewServerWeekFragment
