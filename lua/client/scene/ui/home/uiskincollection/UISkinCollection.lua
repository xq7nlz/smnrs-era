require "lua.client.scene.ui.home.uiSkinCollection.UISkinCollectionModel"
require "lua.client.scene.ui.home.uiSkinCollection.UISkinCollectionView"

--- @class UISkinCollection : UIBase
UISkinCollection = Class(UISkinCollection, UIBase)

--- @return void
function UISkinCollection:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISkinCollection:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISkinCollectionModel()
	self.view = UISkinCollectionView(self.model)
end

return UISkinCollection
