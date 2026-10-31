require "lua.client.scene.ui.home.uiLobbyDomain.UILobbyDomainModel"
require "lua.client.scene.ui.home.uiLobbyDomain.UILobbyDomainView"

--- @class UILobbyDomain : UIBase
UILobbyDomain = Class(UILobbyDomain, UIBase)

--- @return void
function UILobbyDomain:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UILobbyDomain:OnCreate()
	UIBase.OnCreate(self)
	self.model = UILobbyDomainModel()
	self.view = UILobbyDomainView(self.model)
end

return UILobbyDomain
