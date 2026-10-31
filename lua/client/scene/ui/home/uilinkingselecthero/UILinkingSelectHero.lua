require "lua.client.scene.ui.home.uiLinkingSelectHero.UILinkingSelectHeroModel"
require "lua.client.scene.ui.home.uiLinkingSelectHero.UILinkingSelectHeroView"

--- @class UILinkingSelectHero : UIBase
UILinkingSelectHero = Class(UILinkingSelectHero, UIBase)

--- @return void
function UILinkingSelectHero:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UILinkingSelectHero:OnCreate()
    UIBase.OnCreate(self)
    self.model = UILinkingSelectHeroModel()
    self.view = UILinkingSelectHeroView(self.model)
end

return UILinkingSelectHero
