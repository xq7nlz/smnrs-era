require "lua.client.scene.ui.home.uiBoxRewardPreview.UIBoxRewardPreviewModel"
require "lua.client.scene.ui.home.uiBoxRewardPreview.UIBoxRewardPreviewView"

--- @class UIBoxRewardPreview : UIBase
UIBoxRewardPreview = Class(UIBoxRewardPreview, UIBase)

--- @return void
function UIBoxRewardPreview:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIBoxRewardPreview:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIBoxRewardPreviewModel()
	self.view = UIBoxRewardPreviewView(self.model)
end

return UIBoxRewardPreview
