
--- @class UIPopupStageRewardModel : UIBaseModel
UIPopupStageRewardModel = Class(UIPopupStageRewardModel, UIBaseModel)

--- @return void
function UIPopupStageRewardModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIPopupStageReward, "defense_mode_stage_reward")
    self.bgDark = true
end

