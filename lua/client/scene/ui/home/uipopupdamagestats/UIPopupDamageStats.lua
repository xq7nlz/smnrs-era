require "lua.client.scene.ui.home.uiPopupDamageStats.UIPopupDamageStatsModel"
require "lua.client.scene.ui.home.uiPopupDamageStats.UIPopupDamageStatsView"

--- @class UIPopupDamageStats : UIBase
UIPopupDamageStats = Class(UIPopupDamageStats, UIBase)

--- @return void
function UIPopupDamageStats:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupDamageStats:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupDamageStatsModel()
	self.view = UIPopupDamageStatsView(self.model, self.ctrl)
end

return UIPopupDamageStats
