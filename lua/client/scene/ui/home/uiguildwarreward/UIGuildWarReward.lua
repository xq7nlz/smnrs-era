require "lua.client.scene.ui.home.uiGuildWarReward.UIGuildWarRewardModel"
require "lua.client.scene.ui.home.uiGuildWarReward.UIGuildWarRewardView"

--- @class UIGuildWarReward : UIBase
UIGuildWarReward = Class(UIGuildWarReward, UIBase)

--- @return void
function UIGuildWarReward:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildWarReward:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildWarRewardModel()
	self.view = UIGuildWarRewardView(self.model)
end

return UIGuildWarReward
