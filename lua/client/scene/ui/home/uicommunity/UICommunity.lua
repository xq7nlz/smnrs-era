require "lua.client.scene.ui.home.uiCommunity.UICommunityModel"
require "lua.client.scene.ui.home.uiCommunity.UICommunityView"

--- @class UICommunity : UIBase
UICommunity = Class(UICommunity, UIBase)

--- @return void
function UICommunity:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UICommunity:OnCreate()
	UIBase.OnCreate(self)
	self.model = UICommunityModel()
	self.view = UICommunityView(self.model)
end

return UICommunity
