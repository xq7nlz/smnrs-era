require "lua.client.scene.ui.home.uiGuildWarSeasonResult.UIGuildWarSeasonResultModel"
require "lua.client.scene.ui.home.uiGuildWarSeasonResult.UIGuildWarSeasonResultView"

--- @class UIGuildWarSeasonResult : UIBase
UIGuildWarSeasonResult = Class(UIGuildWarSeasonResult, UIBase)

--- @return void
function UIGuildWarSeasonResult:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildWarSeasonResult:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildWarSeasonResultModel()
	self.view = UIGuildWarSeasonResultView(self.model)
end

return UIGuildWarSeasonResult
