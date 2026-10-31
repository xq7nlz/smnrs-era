
--- @class UIDomainsStageMapModel : UIBaseModel
UIDomainsStageMapModel = Class(UIDomainsStageMapModel, UIBaseModel)

--- @return void
function UIDomainsStageMapModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDomainsStageMap, "ui_domains_stage_map")
end

