require "lua.client.scene.ui.home.uiHeroMenu2.UIHeroMenu2Model"
require "lua.client.scene.ui.home.uiHeroMenu2.UIHeroMenu2View"

--- @class UIHeroMenu2 : UIBase
UIHeroMenu2 = Class(UIHeroMenu2, UIBase)

--- @return void
function UIHeroMenu2:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIHeroMenu2:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIHeroMenu2Model()
	self.view = UIHeroMenu2View(self.model)
end

return UIHeroMenu2
