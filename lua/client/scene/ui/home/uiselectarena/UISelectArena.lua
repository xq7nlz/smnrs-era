require "lua.client.scene.ui.home.uiSelectArena.UISelectArenaModel"
require "lua.client.scene.ui.home.uiSelectArena.UISelectArenaView"

--- @class UISelectArena : UIBase
UISelectArena = Class(UISelectArena, UIBase)

--- @return void
function UISelectArena:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectArena:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectArenaModel()
	self.view = UISelectArenaView(self.model)
end

return UISelectArena
