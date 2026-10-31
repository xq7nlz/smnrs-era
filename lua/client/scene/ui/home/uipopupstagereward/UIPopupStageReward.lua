require "lua.client.scene.ui.home.uiPopupStageReward.UIPopupStageRewardModel"
require "lua.client.scene.ui.home.uiPopupStageReward.UIPopupStageRewardView"

--- @class UIPopupStageReward : UIBase
UIPopupStageReward = Class(UIPopupStageReward, UIBase)

--- @return void
function UIPopupStageReward:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIPopupStageReward:OnCreate()
    UIBase.OnCreate(self)
    self.model = UIPopupStageRewardModel()
    self.view = UIPopupStageRewardView(self.model)
end

return UIPopupStageReward
