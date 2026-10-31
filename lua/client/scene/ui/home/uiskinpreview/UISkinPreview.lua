require "lua.client.scene.ui.home.uiSkinPreview.UISkinPreviewModel"
require "lua.client.scene.ui.home.uiSkinPreview.UISkinPreviewView"

--- @class UISkinPreview : UIBase
UISkinPreview = Class(UISkinPreview, UIBase)

--- @return void
function UISkinPreview:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISkinPreview:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISkinPreviewModel()
	self.view = UISkinPreviewView(self.model)
end

return UISkinPreview
