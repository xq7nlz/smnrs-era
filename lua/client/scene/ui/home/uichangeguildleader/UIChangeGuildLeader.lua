require "lua.client.scene.ui.home.uiChangeGuildLeader.UIChangeGuildLeaderModel"
require "lua.client.scene.ui.home.uiChangeGuildLeader.UIChangeGuildLeaderView"

--- @class UIChangeGuildLeader : UIBase
UIChangeGuildLeader = Class(UIChangeGuildLeader, UIBase)

--- @return void
function UIChangeGuildLeader:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIChangeGuildLeader:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIChangeGuildLeaderModel()
	self.view = UIChangeGuildLeaderView(self.model)
end

return UIChangeGuildLeader
