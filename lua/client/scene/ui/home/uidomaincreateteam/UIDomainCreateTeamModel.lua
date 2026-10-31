
--- @class UIDomainCreateTeamModel : UIBaseModel
UIDomainCreateTeamModel = Class(UIDomainCreateTeamModel, UIBaseModel)

--- @return void
function UIDomainCreateTeamModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDomainCreateTeam, "domain_create_team")
	self.bgDark = true
end

