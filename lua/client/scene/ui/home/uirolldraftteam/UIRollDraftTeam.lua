require "lua.client.scene.ui.home.uiRollDraftTeam.UIRollDraftTeamModel"
require "lua.client.scene.ui.home.uiRollDraftTeam.UIRollDraftTeamView"

--- @class UIRollDraftTeam : UIBase
UIRollDraftTeam = Class(UIRollDraftTeam, UIBase)

--- @return void
function UIRollDraftTeam:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIRollDraftTeam:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIRollDraftTeamModel()
	self.view = UIRollDraftTeamView(self.model)
end

return UIRollDraftTeam
