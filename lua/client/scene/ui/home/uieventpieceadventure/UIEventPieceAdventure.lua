require "lua.client.scene.ui.home.uiEventPieceAdventure.UIEventPieceAdventureModel"
require "lua.client.scene.ui.home.uiEventPieceAdventure.UIEventPieceAdventureView"

--- @class UIEventPieceAdventure : UIBase
UIEventPieceAdventure = Class(UIEventPieceAdventure, UIBase)

--- @return void
function UIEventPieceAdventure:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventPieceAdventure:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventPieceAdventureModel()
	self.view = UIEventPieceAdventureView(self.model)
end

return UIEventPieceAdventure
