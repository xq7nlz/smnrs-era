require "lua.client.scene.ui.home.uiSelectMaterialHeroes.UISelectMaterialHeroesModel"
require "lua.client.scene.ui.home.uiSelectMaterialHeroes.UISelectMaterialHeroesView"

--- @class UISelectMaterialHeroes
UISelectMaterialHeroes = Class(UISelectMaterialHeroes, UIBase)

--- @return void
function UISelectMaterialHeroes:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISelectMaterialHeroes:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISelectMaterialHeroesModel()
	self.view = UISelectMaterialHeroesView(self.model, self.ctrl)
end

return UISelectMaterialHeroes
