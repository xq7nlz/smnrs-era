require "lua.client.scene.ui.home.uiArenaTeamSearch.UIArenaTeamSearchModel"
require "lua.client.scene.ui.home.uiArenaTeamSearch.UIArenaTeamSearchView"

--- @class UIArenaTeamSearch : UIBase
UIArenaTeamSearch = Class(UIArenaTeamSearch, UIBase)

--- @return void
function UIArenaTeamSearch:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIArenaTeamSearch:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIArenaTeamSearchModel()
	self.view = UIArenaTeamSearchView(self.model)
end

return UIArenaTeamSearch
