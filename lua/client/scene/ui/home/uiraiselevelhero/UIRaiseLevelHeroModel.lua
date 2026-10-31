--- @class UIRaiseLevelHeroModel : UIBaseModel
UIRaiseLevelHeroModel = Class(UIRaiseLevelHeroModel, UIBaseModel)

--- @return void
function UIRaiseLevelHeroModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIRaiseLevelHero, "ui_raise_level")
    self.bgDark = false
end