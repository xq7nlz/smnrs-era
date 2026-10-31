require "lua.client.scene.ui.home.uiPopupUnbindingRaiseHero.UiPopupUnbindingRaiseHeroModel"
require "lua.client.scene.ui.home.uiPopupUnbindingRaiseHero.UiPopupUnbindingRaiseHeroView"

--- @class UIPopupUnbindingRaiseHero : UIBase
UIPopupUnbindingRaiseHero = Class(UIPopupUnbindingRaiseHero, UIBase)

--- @return void
function UIPopupUnbindingRaiseHero:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIPopupUnbindingRaiseHero:OnCreate()
    UIBase.OnCreate(self)
    self.model = UiPopupUnbindingRaiseHeroModel()
    self.view = UiPopupUnbindingRaiseHeroView(self.model)
end

return UIPopupUnbindingRaiseHero
