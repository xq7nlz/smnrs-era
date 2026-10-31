require "lua.client.scene.ui.home.uiDomainMemberSearch.UIDomainMemberSearchModel"
require "lua.client.scene.ui.home.uiDomainMemberSearch.UIDomainMemberSearchView"

--- @class UIDomainMemberSearch : UIBase
UIDomainMemberSearch = Class(UIDomainMemberSearch, UIBase)

--- @return void
function UIDomainMemberSearch:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDomainMemberSearch:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDomainMemberSearchModel()
	self.view = UIDomainMemberSearchView(self.model)
end

return UIDomainMemberSearch
