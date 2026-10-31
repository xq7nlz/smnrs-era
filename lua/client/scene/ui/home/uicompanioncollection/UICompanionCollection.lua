require "lua.client.scene.ui.home.uiCompanionCollection.UICompanionCollectionModel"
require "lua.client.scene.ui.home.uiCompanionCollection.UICompanionCollectionView"

--- @class UICompanionCollection : UIBase
UICompanionCollection = Class(UICompanionCollection, UIBase)

--- @return void
function UICompanionCollection:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UICompanionCollection:OnCreate()
	UIBase.OnCreate(self)
	self.model = UICompanionCollectionModel()
	self.view = UICompanionCollectionView(self.model)
end

return UICompanionCollection
