--- @class UIRaisePickHeroModel : UIBaseModel
UIRaisePickHeroModel = Class(UIRaisePickHeroModel, UIBaseModel)

--- @return void
function UIRaisePickHeroModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIRaisePickHero, "ui_raise_pick_hero")
    self.type = UIPopupType.NO_BLUR_POPUP
    self.bgDark = true
end