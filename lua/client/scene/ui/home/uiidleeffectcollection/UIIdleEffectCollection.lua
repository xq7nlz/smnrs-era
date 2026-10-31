require "lua.client.scene.ui.home.uiIdleEffectCollection.UIIdleEffectCollectionModel"
require "lua.client.scene.ui.home.uiIdleEffectCollection.UIIdleEffectCollectionView"

--- @class UIIdleEffectCollection : UIBase
UIIdleEffectCollection = Class(UIIdleEffectCollection, UIBase)

--- @return void
function UIIdleEffectCollection:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIIdleEffectCollection:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIIdleEffectCollectionModel()
	self.view = UIIdleEffectCollectionView(self.model)
end

return UIIdleEffectCollection
