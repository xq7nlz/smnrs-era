
--- @class UIDomainChallengeOverModel : UIBaseModel
UIDomainChallengeOverModel = Class(UIDomainChallengeOverModel, UIBaseModel)

--- @return void
function UIDomainChallengeOverModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDomainChallengeOver, "ui_domain_challenge_over")
end

