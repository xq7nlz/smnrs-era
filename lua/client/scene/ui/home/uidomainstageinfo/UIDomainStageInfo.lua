require "lua.client.scene.ui.home.uiDomainStageInfo.UIDomainStageInfoModel"
require "lua.client.scene.ui.home.uiDomainStageInfo.UIDomainStageInfoView"

--- @class UIDomainStageInfo : UIBase
UIDomainStageInfo = Class(UIDomainStageInfo, UIBase)

--- @return void
function UIDomainStageInfo:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDomainStageInfo:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDomainStageInfoModel()
	self.view = UIDomainStageInfoView(self.model)
end

return UIDomainStageInfo
