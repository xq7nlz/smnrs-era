require "lua.client.scene.ui.home.uiItemPreview.UIItemPreviewModel"
require "lua.client.scene.ui.home.uiItemPreview.UIItemPreviewView"

--- @class UIItemPreview
UIItemPreview = Class(UIItemPreview, UIBase)

--- @return void
function UIItemPreview:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIItemPreview:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIItemPreviewModel()
	self.view = UIItemPreviewView(self.model, self.ctrl)
end

return UIItemPreview
