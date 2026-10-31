
--- @class UIPreviewDailyBossModel : UIBaseModel
UIPreviewDailyBossModel = Class(UIPreviewDailyBossModel, UIBaseModel)

--- @return void
function UIPreviewDailyBossModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPreviewDailyBoss, "preview_random_daily_boss")

	self.bgDark = true
end

