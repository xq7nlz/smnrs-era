require "lua.client.scene.ui.home.uiSkillPreview.UISkillPreviewModel"
require "lua.client.scene.ui.home.uiSkillPreview.UISkillPreviewView"

--- @class UISkillPreview
UISkillPreview = Class(UISkillPreview, UIBase)

--- @return void
function UISkillPreview:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISkillPreview:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISkillPreviewModel()
	self.view = UISkillPreviewView(self.model, self.ctrl)
end

return UISkillPreview
