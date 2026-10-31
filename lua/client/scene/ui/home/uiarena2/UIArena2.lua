require "lua.client.scene.ui.home.uiArena2.UIArena2Model"
require "lua.client.scene.ui.home.uiArena2.UIArena2View"

--- @class UIArena2 : UIBase
UIArena2 = Class(UIArena2, UIBase)

--- @return void
function UIArena2:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIArena2:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIArena2Model()
	self.view = UIArena2View(self.model)
end

return UIArena2
