
--- @class UIDefenseStageRecordListModel : UIBaseModel
UIDefenseStageRecordListModel = Class(UIDefenseStageRecordListModel, UIBaseModel)

--- @return void
function UIDefenseStageRecordListModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDefenseStageRecordList, "ui_defense_stage_record_list")
	self.bgDark = true
end

