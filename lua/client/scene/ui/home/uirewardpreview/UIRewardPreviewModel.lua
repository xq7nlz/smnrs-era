
--- @class UIRewardPreviewModel : UIBaseModel
UIRewardPreviewModel = Class(UIRewardPreviewModel, UIBaseModel)

--- @return void
function UIRewardPreviewModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIRewardPreview, "reward_preview")
	self.itemId1 = nil
	self.itemId2 = nil

	self.bgDark = true
end

