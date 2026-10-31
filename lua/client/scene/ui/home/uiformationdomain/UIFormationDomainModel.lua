
--- @class UIFormationDomainModel : UIBaseModel
UIFormationDomainModel = Class(UIFormationDomainModel, UIBaseModel)

--- @return void
function UIFormationDomainModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFormationDomain, "formation_domain")
	self.bgDark = false
end

