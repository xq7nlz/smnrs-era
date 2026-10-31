require "lua.client.scene.ui.home.uiPopupTavernReward.UIPopupTavernRewardModel"
require "lua.client.scene.ui.home.uiPopupTavernReward.UIPopupTavernRewardView"

--- @class UIPopupTavernReward : UIBase
UIPopupTavernReward = Class(UIPopupTavernReward, UIBase)

--- @return void
function UIPopupTavernReward:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupTavernReward:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupTavernRewardModel()
	self.view = UIPopupTavernRewardView(self.model, self.ctrl)
end

return UIPopupTavernReward
