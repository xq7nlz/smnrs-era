require "lua.client.scene.ui.home.uiPopupResetCoolDownRaiseHero.UIPopupResetCoolDownRaiseHeroModel"
require "lua.client.scene.ui.home.uiPopupResetCoolDownRaiseHero.UIPopupResetCoolDownRaiseHeroView"

--- @class UIPopupResetCoolDownRaiseHero : UIBase
UIPopupResetCoolDownRaiseHero = Class(UIPopupResetCoolDownRaiseHero, UIBase)

--- @return void
function UIPopupResetCoolDownRaiseHero:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIPopupResetCoolDownRaiseHero:OnCreate()
    UIBase.OnCreate(self)
    self.model = UIPopupResetCoolDownRaiseHeroModel()
    self.view = UIPopupResetCoolDownRaiseHeroView(self.model)
end

return UIPopupResetCoolDownRaiseHero
