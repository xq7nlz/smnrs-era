
--- @class UISelectHeroPoolModel : UIBaseModel
UISelectHeroPoolModel = Class(UISelectHeroPoolModel, UIBaseModel)

--- @return void
function UISelectHeroPoolModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISelectHeroPool, "select_hero_pool")

	self.bgDark = true
end

