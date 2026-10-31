
--- @class UIWatchAdsModel : UIBaseModel
UIWatchAdsModel = Class(UIWatchAdsModel, UIBaseModel)

--- @return void
function UIWatchAdsModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIWatchAds, "popup_watch_ads")

	self.bgDark = true
end

