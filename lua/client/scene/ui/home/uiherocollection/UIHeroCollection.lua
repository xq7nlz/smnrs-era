require "lua.client.scene.ui.home.uiHeroCollection.UIHeroCollectionModel"
require "lua.client.scene.ui.home.uiHeroCollection.UIHeroCollectionView"

--- @class UIHeroCollection
UIHeroCollection = Class(UIHeroCollection, UIBase)

--- @return void
function UIHeroCollection:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIHeroCollection:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIHeroCollectionModel()
	self.view = UIHeroCollectionView(self.model, self.ctrl)
end

return UIHeroCollection
