
--- @class UIDomainMemberVerifyModel : UIBaseModel
UIDomainMemberVerifyModel = Class(UIDomainMemberVerifyModel, UIBaseModel)

--- @return void
function UIDomainMemberVerifyModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDomainMemberVerify, "domain_member_verify")

	self.bgDark = true
end

