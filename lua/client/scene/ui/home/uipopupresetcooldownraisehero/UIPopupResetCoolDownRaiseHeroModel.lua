--- @class UIPopupResetCoolDownRaiseHeroModel : UIBaseModel
UIPopupResetCoolDownRaiseHeroModel = Class(UIPopupResetCoolDownRaiseHeroModel, UIBaseModel)

--- @return void
function UIPopupResetCoolDownRaiseHeroModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIPopupResetCoolDownRaiseHero, "popup_reset_raise_level")
    self.bgDark = true
end