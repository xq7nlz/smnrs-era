require "lua.client.scene.ui.home.uiEggCombine.UIEggCombineModel"
require "lua.client.scene.ui.home.uiEggCombine.UIEggCombineView"

--- @class UIEggCombine : UIBase
UIEggCombine = Class(UIEggCombine, UIBase)

--- @return void
function UIEggCombine:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEggCombine:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEggCombineModel()
	self.view = UIEggCombineView(self.model)
end

return UIEggCombine
