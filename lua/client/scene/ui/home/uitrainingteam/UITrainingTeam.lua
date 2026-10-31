require "lua.client.scene.ui.home.uiTrainingTeam.UITrainingTeamModel"
require "lua.client.scene.ui.home.uiTrainingTeam.UITrainingTeamView"

--- @class UITrainingTeam : UIBase
UITrainingTeam = Class(UITrainingTeam, UIBase)

--- @return void
function UITrainingTeam:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UITrainingTeam:OnCreate()
	UIBase.OnCreate(self)
	self.model = UITrainingTeamModel()
	self.view = UITrainingTeamView(self.model, self.ctrl)
end

return UITrainingTeam
