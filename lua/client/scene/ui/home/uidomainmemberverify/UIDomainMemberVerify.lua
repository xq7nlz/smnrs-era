require "lua.client.scene.ui.home.uiDomainMemberVerify.UIDomainMemberVerifyModel"
require "lua.client.scene.ui.home.uiDomainMemberVerify.UIDomainMemberVerifyView"

--- @class UIDomainMemberVerify : UIBase
UIDomainMemberVerify = Class(UIDomainMemberVerify, UIBase)

--- @return void
function UIDomainMemberVerify:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDomainMemberVerify:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDomainMemberVerifyModel()
	self.view = UIDomainMemberVerifyView(self.model)
end

return UIDomainMemberVerify
