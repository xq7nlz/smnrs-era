--[[
require "lua.client.scene.ui.home.uiFirstTimeReward.UIFirstTimeRewardModel"
require "lua.client.scene.ui.home.uiFirstTimeReward.UIFirstTimeRewardView"

--- @class UIFirstTimeReward : UIBase
UIFirstTimeReward = Class(UIFirstTimeReward, UIBase)

--- @return void
function UIFirstTimeReward:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFirstTimeReward:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFirstTimeRewardModel()
	self.view = UIFirstTimeRewardView(self.model)
end

return UIFirstTimeReward
]]
