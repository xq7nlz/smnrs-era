require "lua.client.scene.ui.home.uiEventNewHero.UIEventNewHeroModel"
require "lua.client.scene.ui.home.uiEventNewHero.UIEventNewHeroView"

--- @class UIEventNewHero : UIBase
UIEventNewHero = Class(UIEventNewHero, UIBase)

--- @return void
function UIEventNewHero:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventNewHero:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventNewHeroModel()
	self.view = UIEventNewHeroView(self.model)
end

return UIEventNewHero
