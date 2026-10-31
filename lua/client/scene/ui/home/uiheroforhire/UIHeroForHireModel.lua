--- @class UIHeroForHireModel : UIBaseModel
UIHeroForHireModel = Class(UIHeroForHireModel, UIBaseModel)

--- @return void
function UIHeroForHireModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIHeroForHire, "ui_hero_for_hire")
    self.bgDark = true
end