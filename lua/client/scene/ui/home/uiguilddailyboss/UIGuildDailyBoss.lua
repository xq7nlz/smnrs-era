require "lua.client.scene.ui.home.uiGuildDailyBoss.UIGuildDailyBossModel"
require "lua.client.scene.ui.home.uiGuildDailyBoss.UIGuildDailyBossView"

--- @class UIGuildDailyBoss : UIBase
UIGuildDailyBoss = Class(UIGuildDailyBoss, UIBase)

--- @return void
function UIGuildDailyBoss:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildDailyBoss:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildDailyBossModel()
	self.view = UIGuildDailyBossView(self.model, self.ctrl)
end

return UIGuildDailyBoss
