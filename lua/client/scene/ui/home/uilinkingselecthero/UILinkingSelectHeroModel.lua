--- @class UILinkingSelectHeroModel : UIBaseModel
UILinkingSelectHeroModel = Class(UILinkingSelectHeroModel, UIBaseModel)

--- @return void
function UILinkingSelectHeroModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UILinkingSelectHero, "ui_linking_pick_hero")
    self.bgDark = true
end