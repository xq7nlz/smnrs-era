require "lua.client.scene.ui.home.uiPreviewHeroInfo.UIPreviewHeroInfoModel"
require "lua.client.scene.ui.home.uiPreviewHeroInfo.UIPreviewHeroInfoView"

--- @class UIPreviewHeroInfo : UIBase
UIPreviewHeroInfo = Class(UIPreviewHeroInfo, UIBase)

--- @return void
function UIPreviewHeroInfo:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPreviewHeroInfo:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPreviewHeroInfoModel()
	self.view = UIPreviewHeroInfoView(self.model)
end

return UIPreviewHeroInfo
