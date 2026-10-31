
--- @class UIChooseRewardChestArenaModel : UIBaseModel
UIChooseRewardChestArenaModel = Class(UIChooseRewardChestArenaModel, UIBaseModel)

--- @return void
function UIChooseRewardChestArenaModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIChooseRewardChestArena, "chest_arena_choose_reward")
end

