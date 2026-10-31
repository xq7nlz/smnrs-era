require "lua.client.scene.ui.home.uiQuickBattleCollection.UIQuickBattleCollectionModel"
require "lua.client.scene.ui.home.uiQuickBattleCollection.UIQuickBattleCollectionView"

--- @class UIQuickBattleCollection : UIBase
UIQuickBattleCollection = Class(UIQuickBattleCollection, UIBase)

--- @return void
function UIQuickBattleCollection:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIQuickBattleCollection:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIQuickBattleCollectionModel()
	self.view = UIQuickBattleCollectionView(self.model)
end

return UIQuickBattleCollection
