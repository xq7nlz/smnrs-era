require "lua.client.scene.ui.home.uiSelectHeroPool.UISelectHeroPoolModel"
require "lua.client.scene.ui.home.uiSelectHeroPool.UISelectHeroPoolView"

--- @class UISelectHeroPool : UIBase
UISelectHeroPool = Class(UISelectHeroPool, UIBase)

--- @return void
function UISelectHeroPool:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectHeroPool:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectHeroPoolModel()
	self.view = UISelectHeroPoolView(self.model)
end

return UISelectHeroPool
