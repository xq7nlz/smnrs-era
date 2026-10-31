require "lua.client.scene.ui.home.uiArenaReward.UIArenaRewardModel"
require "lua.client.scene.ui.home.uiArenaReward.UIArenaRewardView"

--- @class UIArenaReward : UIBase
UIArenaReward = Class(UIArenaReward, UIBase)

--- @return void
function UIArenaReward:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIArenaReward:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIArenaRewardModel()
	self.view = UIArenaRewardView(self.model)
end

return UIArenaReward
