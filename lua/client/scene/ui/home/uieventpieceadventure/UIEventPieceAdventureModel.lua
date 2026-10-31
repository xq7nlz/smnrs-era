require "lua.client.core.network.event.eventPieceAdventure.EventPieceAdventureModel"

--- @class UIEventPieceAdventureModel : UIBaseModel
UIEventPieceAdventureModel = Class(UIEventPieceAdventureModel, UIBaseModel)

--- @return void
function UIEventPieceAdventureModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventPieceAdventure, "ui_event_piece_adventure")
end

function UIEventPieceAdventureModel:InitListSubEvent()
	self.listSubEvent = List()
	self.listSubEvent:Add(EventPieceAdventureTab.PIECE_ADVENTURE)
	self.listSubEvent:Add(EventPieceAdventureTab.DAILY_QUEST)
	self.listSubEvent:Add(EventPieceAdventureTab.EXCHANGE)
	self.listSubEvent:Add(EventPieceAdventureTab.PIECE_STORE)
end

