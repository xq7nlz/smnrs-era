require "lua.client.scene.ui.home.uiDownloadFont.UIDownloadFontModel"
require "lua.client.scene.ui.home.uiDownloadFont.UIDownloadFontView"

--- @class UIDownloadFont : UIBase
UIDownloadFont = Class(UIDownloadFont, UIBase)

--- @return void
function UIDownloadFont:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDownloadFont:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDownloadFontModel()
	self.view = UIDownloadFontView(self.model)
end

return UIDownloadFont
