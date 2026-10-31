
--- @class UIDomainStageInfoModel : UIBaseModel
UIDomainStageInfoModel = Class(UIDomainStageInfoModel, UIBaseModel)

--- @return void
function UIDomainStageInfoModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDomainStageInfo, "ui_domain_stage_info")

	self.bgDark = true
end

