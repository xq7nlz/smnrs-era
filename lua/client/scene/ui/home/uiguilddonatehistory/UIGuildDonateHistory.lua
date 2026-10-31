require "lua.client.scene.ui.home.uiGuildDonateHistory.UIGuildDonateHistoryModel"
require "lua.client.scene.ui.home.uiGuildDonateHistory.UIGuildDonateHistoryView"

--- @class UIGuildDonateHistory : UIBase
UIGuildDonateHistory = Class(UIGuildDonateHistory, UIBase)

--- @return void
function UIGuildDonateHistory:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildDonateHistory:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildDonateHistoryModel()
	self.view = UIGuildDonateHistoryView(self.model)
end

return UIGuildDonateHistory
