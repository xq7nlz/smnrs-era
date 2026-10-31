require "lua.client.scene.ui.home.uiRaiseLevelHero.UIRaiseLevelHeroModel"
require "lua.client.scene.ui.home.uiRaiseLevelHero.UIRaiseLevelHeroView"

--- @class UIRaiseLevelHero : UIBase
UIRaiseLevelHero = Class(UIRaiseLevelHero, UIBase)

--- @return void
function UIRaiseLevelHero:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIRaiseLevelHero:OnCreate()
    UIBase.OnCreate(self)
    self.model = UIRaiseLevelHeroModel()
    self.view = UIRaiseLevelHeroView(self.model)
end

return UIRaiseLevelHero
