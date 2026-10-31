--- @class UiPopupUnbindingRaiseHeroModel : UIBaseModel
UiPopupUnbindingRaiseHeroModel = Class(UiPopupUnbindingRaiseHeroModel, UIBaseModel)

--- @return void
function UiPopupUnbindingRaiseHeroModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIPopupUnbindingRaiseHero, "popup_unbinding_raise_level")
    self.bgDark = true
end