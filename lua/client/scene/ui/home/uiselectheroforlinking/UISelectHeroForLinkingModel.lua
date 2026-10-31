
--- @class UISelectHeroForLinkingModel : UIBaseModel
UISelectHeroForLinkingModel = Class(UISelectHeroForLinkingModel, UIBaseModel)

--- @return void
function UISelectHeroForLinkingModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectHeroForLinking, "select_hero_for_linking")
	self.bgDark = true
end

