require "lua.client.scene.ui.home.uiPopupReward.UIPopupRewardModel"
require "lua.client.scene.ui.home.uiPopupReward.UIPopupRewardView"

--- @class UIPopupReward : UIBase
UIPopupReward = Class(UIPopupReward, UIBase)

--- @return void
function UIPopupReward:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupReward:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupRewardModel()
	self.view = UIPopupRewardView(self.model)
end

return UIPopupReward
