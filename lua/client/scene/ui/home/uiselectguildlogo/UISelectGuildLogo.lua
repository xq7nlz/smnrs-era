require "lua.client.scene.ui.home.uiSelectGuildLogo.UISelectGuildLogoModel"
require "lua.client.scene.ui.home.uiSelectGuildLogo.UISelectGuildLogoView"

--- @class UISelectGuildLogo : UIBase
UISelectGuildLogo = Class(UISelectGuildLogo, UIBase)

--- @return void
function UISelectGuildLogo:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectGuildLogo:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectGuildLogoModel()
	self.view = UISelectGuildLogoView(self.model)
end

return UISelectGuildLogo
