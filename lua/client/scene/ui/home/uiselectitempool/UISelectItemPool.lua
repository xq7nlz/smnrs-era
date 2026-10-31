require "lua.client.scene.ui.home.uiSelectItemPool.UISelectItemPoolModel"
require "lua.client.scene.ui.home.uiSelectItemPool.UISelectItemPoolView"

--- @class UISelectItemPool : UIBase
UISelectItemPool = Class(UISelectItemPool, UIBase)

--- @return void
function UISelectItemPool:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectItemPool:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectItemPoolModel()
	self.view = UISelectItemPoolView(self.model)
end

return UISelectItemPool
