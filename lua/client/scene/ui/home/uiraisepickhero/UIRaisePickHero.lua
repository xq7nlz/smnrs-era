require "lua.client.scene.ui.home.uiRaisePickHero.UIRaisePickHeroModel"
require "lua.client.scene.ui.home.uiRaisePickHero.UIRaisePickHeroView"

--- @class UIRaisePickHero : UIBase
UIRaisePickHero = Class(UIRaisePickHero, UIBase)

--- @return void
function UIRaisePickHero:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIRaisePickHero:OnCreate()
    UIBase.OnCreate(self)
    self.model = UIRaisePickHeroModel()
    self.view = UIRaisePickHeroView(self.model)
end

return UIRaisePickHero
