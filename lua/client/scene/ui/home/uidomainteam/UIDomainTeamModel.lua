
--- @class UIDomainTeamModel : UIBaseModel
UIDomainTeamModel = Class(UIDomainTeamModel, UIBaseModel)

--- @return void
function UIDomainTeamModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDomainTeam, "domain_team")
end

