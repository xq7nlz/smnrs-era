require "lua.client.scene.ui.home.uiPreviewDailyBoss.UIPreviewDailyBossModel"
require "lua.client.scene.ui.home.uiPreviewDailyBoss.UIPreviewDailyBossView"

--- @class UIPreviewDailyBoss : UIBase
UIPreviewDailyBoss = Class(UIPreviewDailyBoss, UIBase)

--- @return void
function UIPreviewDailyBoss:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPreviewDailyBoss:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPreviewDailyBossModel()
	self.view = UIPreviewDailyBossView(self.model)
end

return UIPreviewDailyBoss
