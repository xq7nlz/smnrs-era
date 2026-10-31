require "lua.client.scene.ui.home.uiRewardPreview.UIRewardPreviewModel"
require "lua.client.scene.ui.home.uiRewardPreview.UIRewardPreviewView"

--- @class UIRewardPreview
UIRewardPreview = Class(UIRewardPreview, UIBase)

--- @return void
function UIRewardPreview:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIRewardPreview:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIRewardPreviewModel()
	self.view = UIRewardPreviewView(self.model, self.ctrl)
end

return UIRewardPreview
