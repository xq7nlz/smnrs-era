require "lua.client.scene.ui.home.uiFormationDomain.UIFormationDomainModel"
require "lua.client.scene.ui.home.uiFormationDomain.UIFormationDomainView"

--- @class UIFormationDomain : UIBase
UIFormationDomain = Class(UIFormationDomain, UIBase)

--- @return void
function UIFormationDomain:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFormationDomain:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFormationDomainModel()
	self.view = UIFormationDomainView(self.model)
end

return UIFormationDomain
