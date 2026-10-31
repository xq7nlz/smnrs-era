require "lua.client.scene.ui.home.uiEventEasterEggExchangeReward.UIEventEasterEggExchangeRewardModel"
require "lua.client.scene.ui.home.uiEventEasterEggExchangeReward.UIEventEasterEggExchangeRewardView"

--- @class UIEasterEggExchangeReward : UIBase
UIEasterEggExchangeReward = Class(UIEasterEggExchangeReward, UIBase)

--- @return void
function UIEasterEggExchangeReward:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEasterEggExchangeReward:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventEasterEggExchangeRewardModel()
	self.view = UIEventEasterEggExchangeRewardView(self.model)
end

return UIEasterEggExchangeReward
