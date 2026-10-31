require "lua.client.scene.ui.home.uiMailPreview.UIMailPreviewModel"
require "lua.client.scene.ui.home.uiMailPreview.UIMailPreviewView"

--- @class UIMailPreview : UIBase
UIMailPreview = Class(UIMailPreview, UIBase)

--- @return void
function UIMailPreview:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIMailPreview:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIMailPreviewModel()
	self.view = UIMailPreviewView(self.model, self.ctrl)
end

return UIMailPreview
