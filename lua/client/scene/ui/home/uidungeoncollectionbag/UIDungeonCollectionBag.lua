require "lua.client.scene.ui.home.uiDungeonCollectionBag.UIDungeonCollectionBagModel"
require "lua.client.scene.ui.home.uiDungeonCollectionBag.UIDungeonCollectionBagView"

--- @class UIDungeonCollectionBag : UIBase
UIDungeonCollectionBag = Class(UIDungeonCollectionBag, UIBase)

--- @return void
function UIDungeonCollectionBag:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDungeonCollectionBag:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDungeonCollectionBagModel()
	self.view = UIDungeonCollectionBagView(self.model)
end

return UIDungeonCollectionBag
