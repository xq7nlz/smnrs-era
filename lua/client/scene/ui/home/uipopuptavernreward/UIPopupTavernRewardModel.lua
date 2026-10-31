
--- @class UIPopupTavernRewardModel : UIBaseModel
UIPopupTavernRewardModel = Class(UIPopupTavernRewardModel, UIBaseModel)

--- @return void
function UIPopupTavernRewardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupTavernReward, "tavern_reward")
	---@type TavernQuestInBound
	self.quest = nil
	---@type List --(HeroResource)
	self.heroResourceList = List()

	self.bgDark = true
end

