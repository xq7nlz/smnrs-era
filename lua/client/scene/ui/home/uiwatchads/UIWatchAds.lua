require "lua.client.scene.ui.home.uiWatchAds.UIWatchAdsModel"
require "lua.client.scene.ui.home.uiWatchAds.UIWatchAdsView"

--- @class UIWatchAds : UIBase
UIWatchAds = Class(UIWatchAds, UIBase)

--- @return void
function UIWatchAds:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIWatchAds:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIWatchAdsModel()
	self.view = UIWatchAdsView(self.model)
end

return UIWatchAds
