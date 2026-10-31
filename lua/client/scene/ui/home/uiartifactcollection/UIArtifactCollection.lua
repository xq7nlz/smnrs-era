require "lua.client.scene.ui.home.uiArtifactCollection.UIArtifactCollectionModel"
require "lua.client.scene.ui.home.uiArtifactCollection.UIArtifactCollectionView"

--- @class UIArtifactCollection : UIBase
UIArtifactCollection = Class(UIArtifactCollection, UIBase)

--- @return void
function UIArtifactCollection:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIArtifactCollection:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIArtifactCollectionModel()
	self.view = UIArtifactCollectionView(self.model)
end

return UIArtifactCollection
