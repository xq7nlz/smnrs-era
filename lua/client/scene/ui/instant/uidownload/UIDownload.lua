require "lua.client.scene.ui.instant.uiDownload.UIDownloadModel"
require "lua.client.scene.ui.instant.uiDownload.UIDownloadView"

--- @class UIDownload : UIBase
UIDownload = Class(UIDownload, UIBase)

--- @return void
function UIDownload:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDownload:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDownloadModel()
	self.view = UIDownloadView(self.model)
end

return UIDownload
