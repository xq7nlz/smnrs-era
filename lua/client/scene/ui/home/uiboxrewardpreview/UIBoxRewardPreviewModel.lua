
--- @class UIBoxRewardPreviewModel : UIBaseModel
UIBoxRewardPreviewModel = Class(UIBoxRewardPreviewModel, UIBaseModel)

--- @return void
function UIBoxRewardPreviewModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIBoxRewardPreview, "ui_box_reward_preview")
	
	--- @type UIPopupType
	self.bgDark = true
end

