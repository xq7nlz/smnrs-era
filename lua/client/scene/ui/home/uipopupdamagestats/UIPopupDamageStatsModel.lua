
--- @class UIPopupDamageStatsModel : UIBaseModel
UIPopupDamageStatsModel = Class(UIPopupDamageStatsModel, UIBaseModel)

--- @return void
function UIPopupDamageStatsModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupDamageStats, "popup_damage_stats")

	self.bgDark = true
end