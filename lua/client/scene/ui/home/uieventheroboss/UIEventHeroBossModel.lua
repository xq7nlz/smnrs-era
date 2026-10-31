
--- @class UIEventHeroBossModel : UIBaseModel
UIEventHeroBossModel = Class(UIEventHeroBossModel, UIBaseModel)

--- @return void
function UIEventHeroBossModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventHeroBoss, "hero_boss_popup")
end

