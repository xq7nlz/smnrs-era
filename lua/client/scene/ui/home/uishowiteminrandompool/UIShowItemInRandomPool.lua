require "lua.client.scene.ui.home.uiShowItemInRandomPool.UIShowItemInRandomPoolModel"
require "lua.client.scene.ui.home.uiShowItemInRandomPool.UIShowItemInRandomPoolView"

--- @class UIShowItemInRandomPool : UIBase
UIShowItemInRandomPool = Class(UIShowItemInRandomPool, UIBase)

--- @return void
function UIShowItemInRandomPool:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIShowItemInRandomPool:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIShowItemInRandomPoolModel()
	self.view = UIShowItemInRandomPoolView(self.model)
end

return UIShowItemInRandomPool
