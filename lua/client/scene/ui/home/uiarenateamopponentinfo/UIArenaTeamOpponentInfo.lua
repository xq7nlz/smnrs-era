require "lua.client.scene.ui.home.uiArenaTeamOpponentInfo.UIArenaTeamOpponentInfoModel"
require "lua.client.scene.ui.home.uiArenaTeamOpponentInfo.UIArenaTeamOpponentInfoView"

--- @class UIArenaTeamOpponentInfo : UIBase
UIArenaTeamOpponentInfo = Class(UIArenaTeamOpponentInfo, UIBase)

--- @return void
function UIArenaTeamOpponentInfo:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIArenaTeamOpponentInfo:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIArenaTeamOpponentInfoModel()
	self.view = UIArenaTeamOpponentInfoView(self.model)
end

return UIArenaTeamOpponentInfo
