
--- @class UIDomainMemberSearchModel : UIBaseModel
UIDomainMemberSearchModel = Class(UIDomainMemberSearchModel, UIBaseModel)

--- @return void
function UIDomainMemberSearchModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDomainMemberSearch, "domain_member_search")

	self.bgDark = true
end

