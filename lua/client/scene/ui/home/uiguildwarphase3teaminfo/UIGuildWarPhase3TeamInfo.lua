require "lua.client.scene.ui.home.uiGuildWarPhase3TeamInfo.UIGuildWarPhase3TeamInfoModel"
require "lua.client.scene.ui.home.uiGuildWarPhase3TeamInfo.UIGuildWarPhase3TeamInfoView"

--- @class UIGuildWarPhase3TeamInfo : UIBase
UIGuildWarPhase3TeamInfo = Class(UIGuildWarPhase3TeamInfo, UIBase)

--- @return void
function UIGuildWarPhase3TeamInfo:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildWarPhase3TeamInfo:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildWarPhase3TeamInfoModel()
	self.view = UIGuildWarPhase3TeamInfoView(self.model)
end

return UIGuildWarPhase3TeamInfo
