
--- @class UIPopupQuestNodeInfoModel : UIBaseModel
UIPopupQuestNodeInfoModel = Class(UIPopupQuestNodeInfoModel, UIBaseModel)

--- @return void
function UIPopupQuestNodeInfoModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupQuestNodeInfo, "popup_quest_node_info")

	self.bgDark = true
end

