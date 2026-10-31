
--- @class UIScrollLoopRewardModel : UIBaseModel
UIScrollLoopRewardModel = Class(UIScrollLoopRewardModel, UIBaseModel)

--- @return void
function UIScrollLoopRewardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIScrollLoopReward, "scroll_loop_reward")

	--- @type List --<ItemIconData>
	self.resourceList = List()

	--- @type string
	self.textButton = nil

	self.bgDark = true
end

